Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 468027F63
	for <xfs@oss.sgi.com>; Wed,  6 Mar 2013 21:56:08 -0600 (CST)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 164718F8073
	for <xfs@oss.sgi.com>; Wed,  6 Mar 2013 19:56:04 -0800 (PST)
Received: from greer.hardwarefreak.com (mo-65-41-216-221.sta.embarqhsd.net
	[65.41.216.221]) by cuda.sgi.com with ESMTP id R5wdKNg6F5b7DRDK
	for <xfs@oss.sgi.com>; Wed, 06 Mar 2013 19:56:03 -0800 (PST)
Message-ID: <51380FD3.5010302@hardwarefreak.com>
Date: Wed, 06 Mar 2013 21:56:03 -0600
From: Stan Hoeppner <stan@hardwarefreak.com>
MIME-Version: 1.0
Subject: Re: XFS filesystem corruption
References: <CAPcwv6wZJSBtgF-L6KNSn6N6Y+wUZJFXdbcg+zYRwoaB2sDdjw@mail.gmail.com>
In-Reply-To: <CAPcwv6wZJSBtgF-L6KNSn6N6Y+wUZJFXdbcg+zYRwoaB2sDdjw@mail.gmail.com>
Reply-To: stan@hardwarefreak.com
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
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: Julien FERRERO <jferrero06@gmail.com>
Cc: xfs@oss.sgi.com

On 3/6/2013 9:08 AM, Julien FERRERO wrote:

> The filesystem was originally created with the command:
> # mkfs.xfs -f -l size=32m /dev/md0

It may be unrelated to your corruption, problem but I'm curious why you
are specifying a 32MB log section instead of letting mkfs.xfs make the
log size decision.

> corruption. I only know that units are used to be power cycle by
> operator while the fs is still mounted (no proper shutdown / reboot).
> My guess is the fs journal shall handle this case and avoid such
> corruption.

As others have stated, this operator needs to be flogged and educated.
A computer based video ingestion/playback system with disk storage and a
complex filesystem is not a tape deck.  You can't can't simply power it
off as if it were a tape deck.

I would assume based on your description that this is a mobile storage
system, often moved from one location to another, probably in a van, and
this is why the operator simply hits the power switch?  Live news crew
type application or similar?

-- 
Stan


_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
