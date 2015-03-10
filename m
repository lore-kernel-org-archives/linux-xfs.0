Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id BBAD87F3F
	for <xfs@oss.sgi.com>; Tue, 10 Mar 2015 12:27:15 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 57342AC001
	for <xfs@oss.sgi.com>; Tue, 10 Mar 2015 10:27:12 -0700 (PDT)
Received: from mail.rvx.is (mail.rvx.is [178.19.51.189]) by cuda.sgi.com with
	ESMTP id JRS8Lgp02E8vgfvH (version=TLSv1 cipher=AES256-SHA
	bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Tue, 10 Mar 2015 10:27:07 -0700 (PDT)
Date: Tue, 10 Mar 2015 17:27:04 +0000 (GMT)
From: Rui Gomes <rgomes@rvx.is>
Message-ID: <1061986380.422955.1426008424991.JavaMail.zimbra@rvx.is>
In-Reply-To: <54FDFEDC.5090106@sandeen.net>
References: <54FDFEDC.5090106@sandeen.net>
Subject: Re: [PATCH] xfs_repair: junk last entry in sf dir if name starts
	beyond dir size
MIME-Version: 1.0
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: Eric Sandeen <sandeen@sandeen.net>
Cc: xfs <xfs@oss.sgi.com>

Hello Eric, 

I clone the xfs git "git://oss.sgi.com/xfs/cmds/xfsprogs" and I couldn't find the code in any of the branch's
Is the code in a public available git?

Regards 

------------------------------- 
Rui Gomes 
CTO 


RVX - Reykjavik Visual Effects 
Seljavegur 2, 
101 Reykjavik 
Iceland 


Tel: + 354 527 3330 
Mob: + 354 663 3360

----- Original Message -----
From: "Eric Sandeen" <sandeen@sandeen.net>
To: "Rui Gomes" <rgomes@rvx.is>, "xfs" <xfs@oss.sgi.com>
Sent: Monday, 9 March, 2015 20:13:16
Subject: [PATCH] xfs_repair: junk last entry in sf dir if name starts beyond dir size

When process_sf_dir2() is trying to salvage entries in a corrupted
short form directory, it may attempt to shorten the last entry in
the dir if it extends beyond the directory size.

However, if the name already starts past the dir size, no amount
of name-shortening will make it fit, but the code doesn't realize
this.  The namelen variable comes out to be negative, and things
go downhill from there, resulting in a segfault when we try to
memmove a negative number of bytes.

If no amount of name-shortening can make the last dir entry fit
in the dir size, simply junk the entry.

Reported by: Rui Gomes <rgomes@rvx.is>
Signed-off-by: Eric Sandeen <sandeen@redhat.com>
---

This adds a bit more spaghetti to an existing pot, but I think
it clearly fixes the problem; I might try to rework these cases
to coalesce some of the code.

(I also wonder about the tradeoff between shortening entries and
increasing the dir size, but for now I'm just following the
direction the repair code already takes).

diff --git a/repair/dir2.c b/repair/dir2.c
index 6b8964d..308808d 100644
--- a/repair/dir2.c
+++ b/repair/dir2.c
@@ -911,6 +911,20 @@ _("zero length entry in shortform dir %" PRIu64 ""),
 				namelen = ino_dir_size -
 					((__psint_t) &sfep->name[0] -
 					 (__psint_t) sfp);
+				/* Entry name starts past size of dir; junk it */
+				if (namelen <= 0) {
+					do_warn(
+_("start of last entry name overflows space left in in shortform dir %" PRIu64 ", "),
+						ino);
+					if (!no_modify)
+						do_warn(
+						_("junking entry #%d\n"), i);
+					else
+						do_warn(
+						_("would junk entry #%d\n"), i);
+					break;
+				}
+				/* Ok, truncate this entry to end of dir */
 				do_warn(
 _("size of last entry overflows space left in in shortform dir %" PRIu64 ", "),
 					ino);

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
