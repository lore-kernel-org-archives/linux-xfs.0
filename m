Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o1CIFPbl012334
	for <linux-xfs@oss.sgi.com>; Fri, 12 Feb 2010 12:15:26 -0600
Received: from lo.gmane.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id EDC621CB5D7
	for <linux-xfs@oss.sgi.com>; Fri, 12 Feb 2010 10:16:40 -0800 (PST)
Received: from lo.gmane.org (lo.gmane.org [80.91.229.12]) by cuda.sgi.com with
	ESMTP id TdxeeK2xGqlVJMYQ for <linux-xfs@oss.sgi.com>;
	Fri, 12 Feb 2010 10:16:40 -0800 (PST)
Received: from list by lo.gmane.org with local (Exim 4.69)
	(envelope-from <sgi-linux-xfs@m.gmane.org>) id 1Ng04F-0005Py-It
	for linux-xfs@oss.sgi.com; Fri, 12 Feb 2010 19:16:39 +0100
Received: from vm15c-113.broadinstitute.org ([69.173.114.122])
	by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
	id 1AlnuQ-0007hv-00
	for <linux-xfs@oss.sgi.com>; Fri, 12 Feb 2010 19:16:39 +0100
Received: from nico by vm15c-113.broadinstitute.org with local (Gmexim 0.1
	(Debian)) id 1AlnuQ-0007hv-00
	for <linux-xfs@oss.sgi.com>; Fri, 12 Feb 2010 19:16:39 +0100
From: Nicolas Stransky <nico@stransky.cx>
Subject: Re: xfs_repair on a 1.5 TiB image has been hanging for about an hour,
	now
Date: Fri, 12 Feb 2010 13:16:16 -0500
Message-ID: <hl45te$kjs$1@ger.gmane.org>
References: <2d460de71002120607g763afc2bt2167fcfbf4664b56@mail.gmail.com>	<4B75738D.80108@sandeen.net>	<2d460de71002120845ue5b127ex1033b37ae5ff6ba2@mail.gmail.com>	<2d460de71002120902g3bda548t4e202dfe43a0c742@mail.gmail.com>	<hl438l$bhm$1@ger.gmane.org>
	<4B7594D3.6040304@sandeen.net>
Mime-Version: 1.0
In-Reply-To: <4B7594D3.6040304@sandeen.net>
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
To: linux-xfs@oss.sgi.com

Right :)
I'm using xfsprogs 3.1.0, on Debian Lenny, because 3.1.1 fails to build
for some reason.
I've been trying to repair a 1.4TB filesystem for more than a week,
without success. xfs_repair never completes. I straced the stuck process
today and got:
Process 28510 attached - interrupt to quit
futex(0x429cb58, FUTEX_WAIT_PRIVATE, 2, NULL

I'm running xfs_repair -P -t5 -m500 /dev/sda1 because the machine only
has 2GB of RAM and was swapping like crazy. I'll see how it goes with
the -P option.

I'm happy to provide xfs_metadump if this still hangs!

Thanks,
    Nico

On 2/12/10 12:50 PM, Eric Sandeen wrote:
> Nicolas Stransky wrote:
>> I'm running into the same problem exactly, except that it's not 10
>> minutes, but DAYS.
>>
>> What is the version that fixes this?
> 
> hard to say without knowing for sure what version you're using, and
> what exactly "this" is that you're seeing :)
> 
> Providing an xfs_metadump of the corrupted fs that hangs repair
> is also about the best thing you could do for investigation,
> if you've already determined that the latest release doesn't help.
> 
> -Eric
> 
>> Thanks
>>
>> On 2/12/10 12:02 PM, Richard Hartmann wrote:
>>> On Fri, Feb 12, 2010 at 17:45, Richard Hartmann
>>> <richih.mailinglist@gmail.com> wrote:
>>>
>>>> I thought about that, but I fear that I will flood my terminal off with crap
>>>> and/or that I somehow impair xfs_repair while doing so.
>>> Running it for ten minutes gives me:
>>>
>>> root@grml ~ # strace -p13629
>>> Process 13629 attached - interrupt to quit
>>> futex(0xa381b4cc, FUTEX_WAIT_PRIVATE, 2, NULL^C <unfinished ...>
>>> Process 13629 detached
>>> root@grml ~ #
>>
>>
> 
> _______________________________________________
> xfs mailing list
> xfs@oss.sgi.com
> http://oss.sgi.com/mailman/listinfo/xfs
> 


-- 
Nico

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
