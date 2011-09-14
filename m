Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p8E7QMYr124519 for <xfs@oss.sgi.com>; Wed, 14 Sep 2011 02:26:22 -0500
Received: from server655-han.de-nserver.de (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 8674B1C0E3A7
	for <xfs@oss.sgi.com>; Wed, 14 Sep 2011 00:26:20 -0700 (PDT)
Received: from server655-han.de-nserver.de (server655-han.de-nserver.de
	[85.158.177.45]) by cuda.sgi.com with ESMTP id 1N98PJHvH1qXEQ2a
	for <xfs@oss.sgi.com>; Wed, 14 Sep 2011 00:26:20 -0700 (PDT)
Message-ID: <4E70571A.80108@profihost.ag>
Date: Wed, 14 Sep 2011 09:26:18 +0200
From: Stefan Priebe - Profihost AG <s.priebe@profihost.ag>
MIME-Version: 1.0
Subject: Re: xfs deadlock in stable kernel 3.0.4
References: <1D2B34A7-7BB9-4E4E-9CA2-382C210E125F@profihost.ag>
	<20110912152133.GA8345@infradead.org>
	<C6515E45-5724-43DD-95A8-1F89AFE29601@profihost.ag>
	<20110912200543.GA22409@infradead.org>
	<4E6EF274.7050007@profihost.ag>
	<20110913205018.GA8543@infradead.org>
In-Reply-To: <20110913205018.GA8543@infradead.org>
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
To: Christoph Hellwig <hch@infradead.org>
Cc: "xfs-masters@oss.sgi.com" <xfs-masters@oss.sgi.com>, aelder@sgi.com, "xfs@oss.sgi.com" <xfs@oss.sgi.com>

Hi,

Am 13.09.2011 22:50, schrieb Christoph Hellwig:
> On Tue, Sep 13, 2011 at 08:04:36AM +0200, Stefan Priebe - Profihost AG wrote:
>> I just reported it to the scsi list as i didn't knew where the
>> problems is. But then some people told be it must be a XFS problem.
>>
>> Some more informations:
>> 1.) It's running with 2.6.32 and 2.6.38
>> 2.) I can also write to another ext2 part on the same disk
>> array(aacraid driver) while xfs stucks - so i think it must be an
>> xfs problem
>
> That points a bit more towards XFS, although we've seen storage setups
> create issues depending on the exact workload.  The prime culprit for
> used to be the md software RAID driver, though.
>
>> 3.) I've also tried running 3.1-rc5 but then i'm seeing this error:
>>
>> BUG: unable to handle kernel NULL pointer dereference at 000000000000012c
>> IP: [] inode_dio_done+0x4/0x25
>
> Oops, that's a bug that I actually introduced myself.  Fix below:

Thanks for the patch.

Now we have the following situation:

1.) Systems running fine with 2.6.32, 2.6.38 and with 3.1 rc-6 + patch
2.) Sadly it does not run with 3.0.4 for more than 1 hour. And 3.0.X 
will become the next long term stable. So there will be a lot of people 
using it.
3.) I have seen this deadlock on systems with aacraid and with intel 
ahci onboard. (that's all we're using)
4.) I still write to other devices / raids on the same controller while 
the XFS root filesystem hangs.

What can we do / try now / next?

Stefan

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
