Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from sandeen.net ([63.231.237.45]:33648 "EHLO sandeen.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S932217AbdELPLG (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Fri, 12 May 2017 11:11:06 -0400
Subject: Re: permanent XFS volume corruption
References: <591493D00200007800158EA3@prv-mh.provo.novell.com>
 <591493D00200007800158EA3@prv-mh.provo.novell.com>
 <a185194a-af56-cd53-cfb9-653e3b5f81b7@sandeen.net>
 <591571BC0200007800159165@prv-mh.provo.novell.com>
 <30296667-47d7-8b94-472a-1d4b96120c09@sandeen.net>
 <5915DE47020000780015946C@prv-mh.provo.novell.com>
 <23c75521-a65b-d105-f274-3d1aba09e6ae@sandeen.net>
From: Eric Sandeen <sandeen@sandeen.net>
Message-ID: <574ee8c5-71f9-eba5-b779-49be4086b6c8@sandeen.net>
Date: Fri, 12 May 2017 10:11:05 -0500
MIME-Version: 1.0
In-Reply-To: <23c75521-a65b-d105-f274-3d1aba09e6ae@sandeen.net>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Jan Beulich <JBeulich@suse.com>
Cc: linux-xfs@vger.kernel.org



On 5/12/17 10:04 AM, Eric Sandeen wrote:
> On 5/12/17 9:09 AM, Jan Beulich wrote:
>>>>> On 12.05.17 at 15:56, <sandeen@sandeen.net> wrote:
>>> On 5/12/17 1:26 AM, Jan Beulich wrote:
>>>> So on the earlier instance, where I did run actual repairs (and
>>>> indeed multiple of them), the problem re-surfaces every time
>>>> I mount the volume again.
>>> Ok, what is the exact sequence there, from repair to re-corruption?
>> Simply mount the volume after repairing (with or without an
>> intermediate reboot) and access respective pieces of the fs
>> again. As said, with /var/run affected on that first occasion,
>> I couldn't even cleanly boot again without seeing the
>> corruption re-surface.
> 
> Mount under what kernel, and access in what way?  I'm looking for a
> recipe to reproduce what you've seen using the metadump you've provided.
> 
> However:
> 
> With further testing I see that xfs_repair v3.1.8 /does not/
> entirely fix the fs; if I run 3.1.8 and then run upstream repair, it
> finds and fixes more bad flags on inode 764 (lib/xenstored/tdb) that 3.1.8
> didn't touch.  The verifiers in an upstream kernel may keep tripping
> over that until newer repair fixes it...

(Indeed just running xfs_repair 3.1.8 finds the same corruption over and over)

Please try a newer xfs_repair, and see if it resolves your problem.

Thanks,
-Eric

> Thanks,
> -Eric
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-xfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 
