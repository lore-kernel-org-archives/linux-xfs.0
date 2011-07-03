Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p63G1f5W044285 for <xfs@oss.sgi.com>; Sun, 3 Jul 2011 11:01:41 -0500
Received: from mail.sandeen.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 8170F1EE6783
	for <xfs@oss.sgi.com>; Sun,  3 Jul 2011 09:01:40 -0700 (PDT)
Received: from mail.sandeen.net (sandeen.net [63.231.237.45]) by cuda.sgi.com
	with ESMTP id 63YxRNGGuQGQYlOb for <xfs@oss.sgi.com>;
	Sun, 03 Jul 2011 09:01:40 -0700 (PDT)
Message-ID: <4E109263.3050803@sandeen.net>
Date: Sun, 03 Jul 2011 11:01:39 -0500
From: Eric Sandeen <sandeen@sandeen.net>
MIME-Version: 1.0
Subject: Re: xfs_growfs doesn't resize
References: <47455.1309470147@sonic.net> <4E1091C7.5040906@sandeen.net>
In-Reply-To: <4E1091C7.5040906@sandeen.net>
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
To: kkeller@sonic.net
Cc: xfs@oss.sgi.com

On 7/3/11 10:59 AM, Eric Sandeen wrote:
> On 6/30/11 4:42 PM, kkeller@sonic.net wrote:
>> # uname -a
>> Linux sahara.xxx 2.6.18-128.1.6.el5 #1 SMP Wed Apr 1 09:10:25 EDT 2009 x86_64 x86_64 x86_64 GNU/Linux
>>
>> Yes, it's not a completely current kernel.  This box is running CentOS 5
>> with some yum updates.
> 
> try
> 
> # rpm -qa | grep xfs
> 
> If you see anything with "kmod" you're running an exceptionally old xfs codebase.
> 
> 2.6.18-138 and beyond should have a newer xfs backport built into the kernel
> rpm itself, as shipped from Red Hat.  But the ancient xfs-kmod (or similar)
> provided xfs.ko will take precedence even if you update that kernel.

... unless you uninstall the xfs-kmod package.

(i'm not sure how to set precedence of found kernel modules, I guess)

-Eric

> * Fri Apr 03 2009 Don Zickus <dzickus@redhat.com> [2.6.18-138.el5]
> ...
> - [fs] xfs:  update to 2.6.28.6 codebase (Eric Sandeen ) [470845]
> 
> If at all possible I'd try an updated kernel, especially if your xfs.ko
> is provided by the very, very, very old centos xfs-kmod rpm.
> 
> -Eric

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
