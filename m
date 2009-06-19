Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	n5JHIARY073734 for <xfs@oss.sgi.com>; Fri, 19 Jun 2009 12:18:11 -0500
Received: from mx2.suse.de (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 900D9129FB24
	for <xfs@oss.sgi.com>; Fri, 19 Jun 2009 10:18:35 -0700 (PDT)
Received: from mx2.suse.de (cantor2.suse.de [195.135.220.15]) by cuda.sgi.com
	with ESMTP id jkSFPDwi9BFJC6Fr for <xfs@oss.sgi.com>;
	Fri, 19 Jun 2009 10:18:35 -0700 (PDT)
From: Andreas Gruenbacher <agruen@suse.de>
Subject: Re: getfacl gives octal output for Hebrew user/group names
Date: Fri, 19 Jun 2009 19:17:45 +0200
References: <4A38F04C.9090909@linux.vnet.ibm.com>
In-Reply-To: <4A38F04C.9090909@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Disposition: inline
Message-Id: <200906191917.45817.agruen@suse.de>
Reply-To: acl-devel@nongnu.org
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
To: Anoop Vijayan <acv@linux.vnet.ibm.com>, acl-devel@nongnu.org
Cc: xfs@oss.sgi.com

Anoop,

On Wednesday 17 June 2009 15:31:56 Anoop Vijayan wrote:
> Hello!
>
> Running RHEL5 U2 x86_64, with Samba & Winbind configure to work with
> Active-Directory env. Users & Groups in the Active-Directory are in hebrew
> and locale settings are correct (Hebrew/UTF-8) Posix Acls on file has
> special characters ('\' & hebrew chars) for the group/user names. In
> circumstances like this, where the user/group accounts come from an AD
> server, getfacl could be showing the "invalid" characters as octal.
> Example:
>
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
> Now - we are also have GPFS fs and when we run the mmgetacl command the
> Posix acls in Hebrew showed OK.
>
> I am trying to work out a patch which fixes this and the issue seems to be
> here
> const char *quote(const char *str)
> [...]
>
> Removing the checks isprint(*s) and *s == '\\' resolves the issue.
> AD shares are associated with a doamin name and AD users/groups will be in
> the format Dom\user. Can someone explain why these checks are required?

The '\\' check is required so that backslashes will go through 
unquote(quote(string)) will come out correctly.

The isprint() check is a misguided attempt to do something reasonable with 
unprintable characters, but it leads to lots of problems with different 
encodings, so it should probably be removed. I'll fix that.

There also is a check for '=' in quote(). This is from the attr package which 
separates names and values with '=', but unnecessary in acl. quote() should 
probably be passed in a string of additional characters that need to be quoted 
so that it does the right thing in both packages.

Thanks,
Andreas

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
