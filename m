Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o81G49qY146955 for <xfs@oss.sgi.com>; Wed, 1 Sep 2010 11:04:09 -0500
Received: from mail.sandeen.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id A53E742464
	for <xfs@oss.sgi.com>; Wed,  1 Sep 2010 09:04:48 -0700 (PDT)
Received: from mail.sandeen.net (64-131-60-146.usfamily.net [64.131.60.146])
	by cuda.sgi.com with ESMTP id pfYOvjuzb9dwjD3A for
	<xfs@oss.sgi.com>; Wed, 01 Sep 2010 09:04:48 -0700 (PDT)
Message-ID: <4C7E799F.8050801@sandeen.net>
Date: Wed, 01 Sep 2010 11:04:47 -0500
From: Eric Sandeen <sandeen@sandeen.net>
MIME-Version: 1.0
Subject: Re: xfsprogs: minimum version with these commands
References: <4C7A2654.3080106@op.pl> <4C7B0EF6.5030505@sandeen.net>
	<4C7BDDB1.6030209@op.pl> <4C7BDFE1.10804@sandeen.net>
	<4C7E7852.9090905@op.pl>
In-Reply-To: <4C7E7852.9090905@op.pl>
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
To: Bogdan <bogdandr@op.pl>
Cc: xfs@oss.sgi.com

Bogdan wrote:

>> I think the fastest route, since nothing you asked for is particularly
>> "new" would be to just grab a sufficiently old version and double check
>> that the commands are there.  Easier than chasing through the repository,
>> I think.
> 
>  Surely. But where do I get such old versions?
> 

CVS should have older but that can be hard to work with

If it's ok with you to use old fedora src.rpms, try:

http://kojipkgs.fedoraproject.org/packages/xfsprogs

which goes back to 2.8.11 in Apr. 2007.

Ah I just found:

ftp://oss.sgi.com/projects/xfs/previous/cmd_tars/xfsprogs-2.7.11.src.tar.gz

as well.

I really think any serious user of xfs will not be using
tools which are more than 5 years old, so if these versions satisfy
your requirements, I wouldn't worry too much about whether older
versions do as well...

-Eric

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
