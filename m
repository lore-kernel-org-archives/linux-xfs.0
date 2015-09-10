Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 3D86A7CBF
	for <xfs@oss.sgi.com>; Thu, 10 Sep 2015 04:22:33 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 30913304039
	for <xfs@oss.sgi.com>; Thu, 10 Sep 2015 02:22:30 -0700 (PDT)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id pe7dun57H8P37Qte (version=TLSv1.2
	cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO) for
	<xfs@oss.sgi.com>; Thu, 10 Sep 2015 02:22:29 -0700 (PDT)
Date: Thu, 10 Sep 2015 11:22:24 +0200
From: Carlos Maiolino <cmaiolino@redhat.com>
Subject: Re: [PATCH 0/13] xfs_repair: recombine cut&waste code in
	dir2.c/attr_repair.c
Message-ID: <20150910092224.GB2613@zion.usersys.redhat.com>
References: <1441827251-13128-1-git-send-email-sandeen@sandeen.net>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <1441827251-13128-1-git-send-email-sandeen@sandeen.net>
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
Cc: xfs@oss.sgi.com

On Wed, Sep 09, 2015 at 02:33:58PM -0500, Eric Sandeen wrote:
> repair/dir2.c and repair/attr_repair.c got cut and pasted
> long, long ago and have diverged since.
> 
> This series brings them back together, presumably fixes some
> bugs, and loses a few hundred lines in the process.
> 
> o/~ reunited, and it feels so so good ... o/~
> 
> The series accomplishes this through a combination of trivial changes
> (removing unused structure members, whitespace, etc) as well
> as by "cross-porting" changes & fixes which happened to one
> file but not the other over the past many years.
> 
> Along the way, a graphical diff of dir2 vs. attr_repair should
> show the convergence.
> 
> Up until the last patch, I don't worry about dir vs. attr naming
> in comments or error messages; the goal is to make these chunks
> of the two files sufficiently similar so that by patch 11, the
> reviewer can do a diff and say "yeah, ok, those really are
> substantially the same now."
> 
> Also instructive is to apply up to patch 11, copy dir2.c and
> attr_repair.c to /tmp, apply patch 12, and do a 3-way graphical
> diff of the 3 files to see that the move really is OK and
> didn't play any significant tricks.
> 
> The last patch fixes up the dir vs. attr text in error messages
> and comments.  I do have a question about whether this is ok
> for i8n:
> 
> 	printf(_("This string is %s"), _("awesome"));

This should be fine for i18n, I had used it a lot when I added i18n support in
gfs2-utils, and _() is the default macro that should embrace every string that
needs to be translated. It will be replaced by gettext("awesome"), and there is
no problem in using it as printf() argument for format specifiers.

What you should be careful though, is that how these strings will 'look' to the
person translating it, which, in most of cases, they are not going to look at
the code to get a better meaning of the string. So, the sentences to be
translated, should make sense by itself.


I particularly, don't like much the idea of split strings as you did in the
example, exactly because how it might look to the translators, both strings
makes the same sentence, but they will show to the translators as completely
different strings, and the translator might not be able to find the proper
grammatical construction. So, I'd do something like:

printf(funny ? _("This string is awesome") : _("This string is boring")) 


I know that I might sound picky here, but, this is the best way to avoid weird
and non-sense string translations.

>
> because that's essentially the trick I used...
> 
> Thanks,
> -Eric
> 
> _______________________________________________
> xfs mailing list
> xfs@oss.sgi.com
> http://oss.sgi.com/mailman/listinfo/xfs

-- 
Carlos

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
