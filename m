Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o1CHmvHH010343
	for <linux-xfs@oss.sgi.com>; Fri, 12 Feb 2010 11:48:57 -0600
Received: from mail.sandeen.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 3842E1CC77EF
	for <linux-xfs@oss.sgi.com>; Fri, 12 Feb 2010 09:50:11 -0800 (PST)
Received: from mail.sandeen.net (64-131-60-146.usfamily.net [64.131.60.146])
	by cuda.sgi.com with ESMTP id vYoLagIM1xF85zuB for
	<linux-xfs@oss.sgi.com>; Fri, 12 Feb 2010 09:50:11 -0800 (PST)
Message-ID: <4B7594D3.6040304@sandeen.net>
Date: Fri, 12 Feb 2010 11:50:11 -0600
From: Eric Sandeen <sandeen@sandeen.net>
MIME-Version: 1.0
Subject: Re: xfs_repair on a 1.5 TiB image has been hanging for about an hour,
	now
References: <2d460de71002120607g763afc2bt2167fcfbf4664b56@mail.gmail.com>	<4B75738D.80108@sandeen.net>	<2d460de71002120845ue5b127ex1033b37ae5ff6ba2@mail.gmail.com>	<2d460de71002120902g3bda548t4e202dfe43a0c742@mail.gmail.com>
	<hl438l$bhm$1@ger.gmane.org>
In-Reply-To: <hl438l$bhm$1@ger.gmane.org>
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
To: Nicolas Stransky <nico@stransky.cx>
Cc: linux-xfs@oss.sgi.com

Nicolas Stransky wrote:
> I'm running into the same problem exactly, except that it's not 10
> minutes, but DAYS.
> 
> What is the version that fixes this?

hard to say without knowing for sure what version you're using, and
what exactly "this" is that you're seeing :)

Providing an xfs_metadump of the corrupted fs that hangs repair
is also about the best thing you could do for investigation,
if you've already determined that the latest release doesn't help.

-Eric

> Thanks
> 
> On 2/12/10 12:02 PM, Richard Hartmann wrote:
>> On Fri, Feb 12, 2010 at 17:45, Richard Hartmann
>> <richih.mailinglist@gmail.com> wrote:
>>
>>> I thought about that, but I fear that I will flood my terminal off with crap
>>> and/or that I somehow impair xfs_repair while doing so.
>> Running it for ten minutes gives me:
>>
>> root@grml ~ # strace -p13629
>> Process 13629 attached - interrupt to quit
>> futex(0xa381b4cc, FUTEX_WAIT_PRIVATE, 2, NULL^C <unfinished ...>
>> Process 13629 detached
>> root@grml ~ #
> 
> 

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
