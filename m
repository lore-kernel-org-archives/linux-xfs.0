Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	n5HDUICs214794 for <xfs@oss.sgi.com>; Wed, 17 Jun 2009 08:30:19 -0500
Received: from e9.ny.us.ibm.com (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 133861ADAF3D
	for <xfs@oss.sgi.com>; Wed, 17 Jun 2009 06:30:42 -0700 (PDT)
Received: from e9.ny.us.ibm.com (e9.ny.us.ibm.com [32.97.182.139]) by
	cuda.sgi.com with ESMTP id ZhKQBBfMKVR9VGDq for
	<xfs@oss.sgi.com>; Wed, 17 Jun 2009 06:30:42 -0700 (PDT)
Received: from d01relay04.pok.ibm.com (d01relay04.pok.ibm.com [9.56.227.236])
	by e9.ny.us.ibm.com (8.13.1/8.13.1) with ESMTP id n5HDI75Z005491
	for <xfs@oss.sgi.com>; Wed, 17 Jun 2009 09:18:07 -0400
Received: from d01av03.pok.ibm.com (d01av03.pok.ibm.com [9.56.224.217])
	by d01relay04.pok.ibm.com (8.13.8/8.13.8/NCO v9.2) with ESMTP id
	n5HDUeOG227760 for <xfs@oss.sgi.com>; Wed, 17 Jun 2009 09:30:40 -0400
Received: from d01av03.pok.ibm.com (loopback [127.0.0.1])
	by d01av03.pok.ibm.com (8.12.11.20060308/8.13.3) with ESMTP id
	n5HDUd6o010272 for <xfs@oss.sgi.com>; Wed, 17 Jun 2009 09:30:39 -0400
Received: from anoopf10.in.ibm.com (anoopf10.in.ibm.com [9.124.35.205])
	by d01av03.pok.ibm.com (8.12.11.20060308/8.12.11) with ESMTP id
	n5HDUceT010120 for <xfs@oss.sgi.com>; Wed, 17 Jun 2009 09:30:39 -0400
Message-ID: <4A38F04C.9090909@linux.vnet.ibm.com>
Date: Wed, 17 Jun 2009 19:01:56 +0530
From: Anoop Vijayan <acv@linux.vnet.ibm.com>
MIME-Version: 1.0
Subject: getfacl gives octal output for Hebrew user/group names
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset="us-ascii"; Format="flowed"
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: xfs@oss.sgi.com

Hello!

Running RHEL5 U2 x86_64, with Samba & Winbind configure to work with Active-Directory env.
Users & Groups in the Active-Directory are in hebrew and locale settings are correct (Hebrew/UTF-8)
Posix Acls on file has special characters ('\' & hebrew chars) for the group/user names.
In circumstances like this, where the user/group accounts come from an AD
server, getfacl could be showing the "invalid" characters as octal.
Example:

[root]# getfacl a.a
# file: a.a
# owner: GTS\134\327\236\327\225\327\251\327\225\327\237
# group: root
user::rw-
group::r--
group:GTS\134\327\251\327\236\327\225\327\250:-w-
group:GTS\134\327\251\327\250\327\252:r-x
mask::rwx
other::r--

Now - we are also have GPFS fs and when we run the mmgetacl command the Posix
acls in Hebrew showed OK.

I am trying to work out a patch which fixes this and the issue seems to be here
const char *quote(const char *str)
{
     static char *quoted_str;
     static size_t quoted_str_len;
     const unsigned char *s;
     char *q;
     size_t nonpr;

     if (!str)
         return str;

     for (nonpr = 0, s = (unsigned char *)str; *s != '\0'; s++)
         if (!isprint(*s) || isspace(*s) || *s == '\\' || *s == '=') <========
             nonpr++;
     if (nonpr == 0)
         return str;

     if (high_water_alloc((void **)&quoted_str, &quoted_str_len,
                  (s - (unsigned char *)str) + nonpr * 3 + 1))
         return NULL;
     for (s = (unsigned char *)str, q = quoted_str; *s != '\0'; s++) {
         if (!isprint(*s) || isspace(*s) || *s == '\\' || *s == '=') { <========
             *q++ = '\\';
             *q++ = '0' + ((*s >> 6)    );
             *q++ = '0' + ((*s >> 3) & 7);
             *q++ = '0' + ((*s     ) & 7);
         } else
             *q++ = *s;
     }

Removing the checks isprint(*s) and *s == '\\' resolves the issue.
AD shares are associated with a doamin name and AD users/groups will be in the format Dom\user.
Can someone explain why these checks are required?

PS. Please include me in the reply as I have not subscribed to this list.

Cheers!
- Anoop

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
