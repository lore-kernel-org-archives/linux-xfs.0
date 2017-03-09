Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from sandeen.net ([63.231.237.45]:58064 "EHLO sandeen.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752336AbdCIVZT (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Thu, 9 Mar 2017 16:25:19 -0500
Subject: Re: pquota + xfs_fsr cron
References: <CAL8yqiigz_ShyH=YE5GqxP+V5jRiMJLPSQpWbcsAiCzzQfsP_A@mail.gmail.com>
From: Eric Sandeen <sandeen@sandeen.net>
Message-ID: <f1998849-860f-990b-3b8e-9170307c6592@sandeen.net>
Date: Thu, 9 Mar 2017 15:25:17 -0600
MIME-Version: 1.0
In-Reply-To: <CAL8yqiigz_ShyH=YE5GqxP+V5jRiMJLPSQpWbcsAiCzzQfsP_A@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: fuser ct1 <fuserct1@gmail.com>, linux-xfs@vger.kernel.org

On 3/9/17 5:08 AM, fuser ct1 wrote:
> Hello list,
> 
> Many of the posts here are DLEVEL, so I hope this won't seem too pedestrian.
> 
> My questions are:
> 
> 
> 1) do project quota's noticeably slow xfs down?
> 
> That might sound silly, but I'm planning to use them quite
> extensively. Sure, initializing the quota can take a while (I don't
> want to limit the depth), but aside from this can't find any ill
> effects in the lab.

It sounds like you've answered your own question?
It should be about the same as user or group quota; I'm not aware
of any significant overhead.

> 
> 2) is it moronic to do a nightly xfs_fsr?

yes ;)

> It seems reasonable that my system defrag XFS volumes automatically.
> 
> The problem is I often don't have access my machines (no SSH), so
> would like to leave this simple option in place.
> 
> Sure I can write a little script to check the defrag % then act
> accordingly, but xfs_fsr seems like it would already work.

Well,
http://xfs.org/index.php/XFS_FAQ#Q:_The_xfs_db_.22frag.22_command_says_I.27m_over_50.25._Is_that_bad.3F

TBH the best plan is to avoid fragmentation to start with.

fsr may reassemble fragmented files, but in the process it may fragment
freespace.  running fsr in cron is not recommended.

> 
> 3) Finally, according to the docs, unless instructed otherwise xfs_fsr
> should check all XFS volumes present in mtab. My lab box only has one
> volume, but supposing there were two (or more) should I expect it to
> divide the 2 hours time it spends nightly between all mounted XFS
> volumes?

maybe, but I wouldn't have it do that.

don't run fsr unless you know fragmentation is a problem; and if you
know fragmentation is a problem, there are tools to avoid it up front,
vs. cleaning up after the fact.

-Eric

> 
> Thanks in advance!
> 
> fUSER
> --
> To unsubscribe from this list: send the line "unsubscribe linux-xfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 
