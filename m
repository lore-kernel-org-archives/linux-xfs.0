Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	n5GM4ohI181220
	for <linux-xfs@oss.sgi.com>; Tue, 16 Jun 2009 17:04:51 -0500
Received: from mail.sandeen.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 1C0B4126A086
	for <linux-xfs@oss.sgi.com>; Tue, 16 Jun 2009 15:05:14 -0700 (PDT)
Received: from mail.sandeen.net (sandeen.net [209.173.210.139]) by
	cuda.sgi.com with ESMTP id aMWmDScO8pGwFVNP for
	<linux-xfs@oss.sgi.com>; Tue, 16 Jun 2009 15:05:14 -0700 (PDT)
Message-ID: <4A38171A.4080500@sandeen.net>
Date: Tue, 16 Jun 2009 17:05:14 -0500
From: Eric Sandeen <sandeen@sandeen.net>
MIME-Version: 1.0
Subject: Re: XFS Preallocate using ALLOCSP
References: <24042506.post@talk.nabble.com> <4A3712BF.7030101@sandeen.net>	
	<8770d98c0906152344p185533a9rc144a5667d13d2de@mail.gmail.com>	
	<4A37B744.9030301@sandeen.net>	
	<0B774481-16A5-42FC-89C3-91096E59E861@sgi.com>	
	<8770d98c0906161028j1cc5cbadl49d30092fddf3dbe@mail.gmail.com>	
	<B7C1A222-58C5-4858-80B4-F871BF088DB1@sgi.com>
	<8770d98c0906161442t634467bxe8b0f5c32b49502e@mail.gmail.com>
In-Reply-To: <8770d98c0906161442t634467bxe8b0f5c32b49502e@mail.gmail.com>
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
To: Smit Shah <getsmit@gmail.com>
Cc: linux-xfs@oss.sgi.com

Smit Shah wrote:
> On 6/16/09, Felix Blyakher <felixb@sgi.com> wrote:

>>> but the write performance is going to suffer.
>> It's not clear why it should. Not doing preallocation doesn't
>> mean that there is no inode updates with every write. Why
>> would extent conversion be more expensive that creating the
>> space (extent) and updating the inode size for every write?
>> It'd interesting to reproduce your results. Any details on
>> your tests and the iometer usage?
> 
> Since fallocate uses the RESVSP cmd for xfs. And as given given for
> RESVSP in man page for xfsctl
> If the  XFS filesystem  is  configured to flag unwritten file extents,
> performance will be negatively affected when writing to preallocated
> space, since extra filesystem transactions are required to convert
> extent  flags  on  the  range  of  the  file  written.

And ext4 must do basically the same thing, as would any fs that flags
unwritten extents.

ext4 may convert more at a time, though, rather than leaving
"fragmented" written/unwritten/written/unwritten regions.

-Eric

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
