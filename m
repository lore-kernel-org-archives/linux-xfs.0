Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o6RD8A30187151 for <xfs@oss.sgi.com>; Tue, 27 Jul 2010 08:08:11 -0500
Received: from mail.sandeen.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id E82A012BA29F
	for <xfs@oss.sgi.com>; Tue, 27 Jul 2010 06:18:35 -0700 (PDT)
Received: from mail.sandeen.net (64-131-60-146.usfamily.net [64.131.60.146])
	by cuda.sgi.com with ESMTP id Z0kBeqrn8iXut1tj for
	<xfs@oss.sgi.com>; Tue, 27 Jul 2010 06:18:35 -0700 (PDT)
References: <1274710459-11446-1-git-send-email-jack@suse.cz>
	<1274710459-11446-5-git-send-email-jack@suse.cz>
	<4C0FD43D.3040803@sandeen.net>
	<20100615095505.GB3347@quack.suse.cz>
	<4C4E0229.5040002@sandeen.net>
	<20100727081538.GB3358@quack.suse.cz>
	<20100727084848.GC3358@quack.suse.cz>
In-Reply-To: <20100727084848.GC3358@quack.suse.cz>
Mime-Version: 1.0 (iPhone Mail 8A293)
Message-Id: <9EBA299E-8A0B-4610-B8FA-3A97FECFA0A4@sandeen.net>
From: Eric Sandeen <sandeen@sandeen.net>
Subject: Re: [PATCH 4/8] Add test of quota accounting using fsx
Date: Tue, 27 Jul 2010 08:11:30 -0500
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
To: Jan Kara <jack@suse.cz>
Cc: "hch@infradead.org" <hch@infradead.org>, ext4 development <linux-ext4@vger.kernel.org>, "xfs@oss.sgi.com" <xfs@oss.sgi.com>

On Jul 27, 2010, at 3:48 AM, Jan Kara <jack@suse.cz> wrote:

>>> 
>>  Just last week a change went into xfstests which introduces a generic
>> quota checking function and uses sync before getting quota usage. I think
>> xfstests passed for me with ext4 after this change but I've now restarted
>> the tests to recheck it.
>  For me all the quota tests pass just fine with ext4 and the latest
> xfstests... So does the latest version work also for you?
> 
Whoops sorry, they do pass for me in the devel tree; I had missed that recent change and I guess our qa had tested a tree without it.  I wondered why it didn't work for them...  Sorry for the noise....

Eric

>                                    Honza
> --
> Jan Kara <jack@suse.cz>
> SUSE Labs, CR
> 

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
