Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	n5HEIT4H218307 for <xfs@oss.sgi.com>; Wed, 17 Jun 2009 09:18:29 -0500
Received: from mail.sandeen.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id C91BC30221A
	for <xfs@oss.sgi.com>; Wed, 17 Jun 2009 07:18:53 -0700 (PDT)
Received: from mail.sandeen.net (sandeen.net [209.173.210.139]) by
	cuda.sgi.com with ESMTP id 0RLcHfbUrB5wH5AF for
	<xfs@oss.sgi.com>; Wed, 17 Jun 2009 07:18:53 -0700 (PDT)
Message-ID: <4A38FB4B.20002@sandeen.net>
Date: Wed, 17 Jun 2009 09:18:51 -0500
From: Eric Sandeen <sandeen@sandeen.net>
MIME-Version: 1.0
Subject: Re: getfacl gives octal output for Hebrew user/group names
References: <4A38F04C.9090909@linux.vnet.ibm.com>
In-Reply-To: <4A38F04C.9090909@linux.vnet.ibm.com>
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
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: Anoop Vijayan <acv@linux.vnet.ibm.com>
Cc: acl-devel@nongnu.org, xfs@oss.sgi.com

Anoop Vijayan wrote:
> Hello!
> 
> Running RHEL5 U2 x86_64, with Samba & Winbind configure to work with Active-Directory env.
> Users & Groups in the Active-Directory are in hebrew and locale settings are correct (Hebrew/UTF-8)
> Posix Acls on file has special characters ('\' & hebrew chars) for the group/user names.
> In circumstances like this, where the user/group accounts come from an AD
> server, getfacl could be showing the "invalid" characters as octal.
> Example:

cc'ing back to the new acl list.

-Eric

> [root]# getfacl a.a
> # file: a.a
> # owner: GTS\134\327\236\327\225\327\251\327\225\327\237
> # group: root
> user::rw-
> group::r--
> group:GTS\134\327\251\327\236\327\225\327\250:-w-
> group:GTS\134\327\251\327\250\327\252:r-x
> mask::rwx
> other::r--
> 
> Now - we are also have GPFS fs and when we run the mmgetacl command the Posix
> acls in Hebrew showed OK.
> 
> I am trying to work out a patch which fixes this and the issue seems to be here
> const char *quote(const char *str)
> {
>      static char *quoted_str;
>      static size_t quoted_str_len;
>      const unsigned char *s;
>      char *q;
>      size_t nonpr;
> 
>      if (!str)
>          return str;
> 
>      for (nonpr = 0, s = (unsigned char *)str; *s != '\0'; s++)
>          if (!isprint(*s) || isspace(*s) || *s == '\\' || *s == '=') <========
>              nonpr++;
>      if (nonpr == 0)
>          return str;
> 
>      if (high_water_alloc((void **)&quoted_str, &quoted_str_len,
>                   (s - (unsigned char *)str) + nonpr * 3 + 1))
>          return NULL;
>      for (s = (unsigned char *)str, q = quoted_str; *s != '\0'; s++) {
>          if (!isprint(*s) || isspace(*s) || *s == '\\' || *s == '=') { <========
>              *q++ = '\\';
>              *q++ = '0' + ((*s >> 6)    );
>              *q++ = '0' + ((*s >> 3) & 7);
>              *q++ = '0' + ((*s     ) & 7);
>          } else
>              *q++ = *s;
>      }
> 
> Removing the checks isprint(*s) and *s == '\\' resolves the issue.
> AD shares are associated with a doamin name and AD users/groups will be in the format Dom\user.
> Can someone explain why these checks are required?
> 
> PS. Please include me in the reply as I have not subscribed to this list.
> 
> Cheers!
> - Anoop
> 
> _______________________________________________
> xfs mailing list
> xfs@oss.sgi.com
> http://oss.sgi.com/mailman/listinfo/xfs
> 

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
