Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 89A4E7F50
	for <xfs@oss.sgi.com>; Wed,  5 Mar 2014 18:53:11 -0600 (CST)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 7283A304066
	for <xfs@oss.sgi.com>; Wed,  5 Mar 2014 16:53:08 -0800 (PST)
Received: from mail-ig0-f171.google.com (mail-ig0-f171.google.com
	[209.85.213.171]) by cuda.sgi.com with ESMTP id
	7bGBI1BkkvFpLMxI (version=TLSv1 cipher=RC4-SHA bits=128
	verify=NO) for <xfs@oss.sgi.com>;
	Wed, 05 Mar 2014 16:53:07 -0800 (PST)
Received: by mail-ig0-f171.google.com with SMTP id hl1so12426717igb.4
	for <xfs@oss.sgi.com>; Wed, 05 Mar 2014 16:53:07 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <20140305233551.GK6851@dastard>
References: <CANGgnMYPLF+8616Rs9eQOXUc9He2NSgFnNrvHvepV-x+pWS6oQ@mail.gmail.com>
	<20140305233551.GK6851@dastard>
Date: Wed, 5 Mar 2014 16:53:06 -0800
Message-ID: <CANGgnMb=2dYGQO4K36pQ9LEb8E4rT6S_VskLF+n=ndd0_kJr_g@mail.gmail.com>
Subject: Re: XFS crash?
From: Austin Schuh <austin@peloton-tech.com>
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
To: Dave Chinner <david@fromorbit.com>
Cc: xfs <xfs@oss.sgi.com>

Hi Dave,

On Wed, Mar 5, 2014 at 3:35 PM, Dave Chinner <david@fromorbit.com> wrote:
> On Wed, Mar 05, 2014 at 03:08:16PM -0800, Austin Schuh wrote:
>> Howdy,
>>
>> I'm running a config_preempt_rt patched version of the 3.10.11 kernel,
>> and I'm seeing a couple lockups and crashes which I think are related
>> to XFS.
>
> I think they ar emore likely related to RT issues....
>

That very well may be true.

> Your usb device has disconnected and gone down the device
> removal/invalidate partition route. and it's trying to flush the
> device, which is stuck on IO completion which is stuck waiting for
> the device error handling to error them out.
>
> So, this is a block device problem error handling problem caused by
> device unplug getting stuck because it's decided to ask the
> filesystem to complete operations that can't be completed until the
> device error handling progress far enough to error out the IOs that
> the filesystem is waiting for completion on.
>
> Cheers,
>
> Dave.
> --
> Dave Chinner
> david@fromorbit.com

I unplugged the USB device _after_ the rest of the system started
locking up to see if that might unstick things.

Austin

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
