Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0F59DC433FE
	for <linux-xfs@archiver.kernel.org>; Mon, 21 Nov 2022 16:14:09 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230032AbiKUQOI (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 21 Nov 2022 11:14:08 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44016 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229541AbiKUQOH (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 21 Nov 2022 11:14:07 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 64344D298C
        for <linux-xfs@vger.kernel.org>; Mon, 21 Nov 2022 08:14:06 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id B64CD61301
        for <linux-xfs@vger.kernel.org>; Mon, 21 Nov 2022 16:14:05 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 31281C433C1;
        Mon, 21 Nov 2022 16:14:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1669047245;
        bh=gmkeJaqd3a2h3yvK0kLzAJIB6oFFDs0q9ABEmtksT9M=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=PHw8CUlsY7n5cingfbTRDoEVfV+ou5jBZutZP3Z+KeQWqPrNBjz6OBJBNs6lwSX76
         cemSFN/YvUUxYXRdv3ahclwuPtaLYBAxZtslt1fbpZKi9KiJxGnxx3AVc5KjfXjfH2
         snsSOrORE+9zC1nwAks7GzP0EO7KyryJg9WYhNb+LKbw5eMDbHoDn0cU+GO2iQjhIz
         qclJtANgVdpTQOxqOHoEmra4QjKWIcP4FNqR32vWdZXCD5JcO3Ojn0rZaUZapZl6zL
         NpqM6XrmXW+gYAtKgTvkRbHfeJrYU3JPireSl6/fTAkXKKyTR50nTcHW2e80NAiCei
         0lyGjgCh+Pt7w==
Date:   Mon, 21 Nov 2022 17:14:00 +0100
From:   Carlos Maiolino <cem@kernel.org>
To:     iamdooser <iamdooser@gmail.com>
Cc:     Eric Sandeen <sandeen@redhat.com>, linux-xfs@vger.kernel.org
Subject: Re: xfs_repair hangs at "process newly discovered inodes..."
Message-ID: <20221121161400.tecpfwaawiy4kt3y@andromeda>
References: <f7f94312-ad1b-36e4-94bf-1b7f47070c1e@gmail.com>
 <39028244-fec6-6717-d8a7-b9f89f5a1f3b@redhat.com>
 <iOca9P0A2zA99RMVQ0MVU2m_jc4mmNS3eLXM-c7gkAp5rCgJNxdoaX6xoCN3-ByUS-4whve0zMZucYirzgGw-A==@protonmail.internalid>
 <8ed7c0ee-dd04-8346-87cb-83c2222f3454@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <8ed7c0ee-dd04-8346-87cb-83c2222f3454@gmail.com>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Hi.


On Sat, Nov 19, 2022 at 12:24:18PM -0500, iamdooser wrote:
> Thank you for responding.
> 
> Yes that found errors, although I'm not accustomed to interpreting the
> output.
> 
> xfs_repair version 5.18.0
> 
> The output of xfs_repair -nv was quite large, as was the
> xfs_metadump...not sure that's indicative of something, but I've
> uploaded them here:
> https://drive.google.com/drive/folders/1OyQOZNsTS1w1Utx1ZfQEH-bS_Cyj8-F2?usp=sharing
> 
> 
> There doesn't seem to be much activity once it hangs at "process newly
> discovered inodes..." so it doesn't seem like just a slow repair.
> Desipte there being no sign of activity, I've let it run for 24+ hours
> and saw no changes..
> 

Before anything else, could you please try to run the latest xfsprogs from:

https://git.kernel.org/pub/scm/fs/xfs/xfsprogs-dev.git/log/?h=master

A quick test in my laptop using the metadump you provided, finished the repair
in about 5 mintues:

Maximum metadata LSN (2138201505:-135558109) is ahead of log (96:0).
Format log to cycle 2138201508.

        XFS_REPAIR Summary    Mon Nov 21 17:04:44 2022

Phase		Start		End		Duration
Phase 1:	11/21 16:59:36	11/21 16:59:36	
Phase 2:	11/21 16:59:36	11/21 16:59:37	1 second
Phase 3:	11/21 16:59:37	11/21 17:03:47	4 minutes, 10 seconds
Phase 4:	11/21 17:03:47	11/21 17:04:06	19 seconds
Phase 5:	11/21 17:04:06	11/21 17:04:07	1 second
Phase 6:	11/21 17:04:07	11/21 17:04:38	31 seconds
Phase 7:	11/21 17:04:38	11/21 17:04:38	

Total run time: 5 minutes, 2 seconds
done

Also, feel free to compress any file you need to share with us :)

Cheers.

> 
> On 11/17/22 13:48, Eric Sandeen wrote:
> > On 11/17/22 12:40 PM, iamdooser wrote:
> >> Hello,
> >>
> >> I'm not sure this is the correct forum; if not I'd appreciate guidance.
> >>
> >> I have a Unraid machine that experienced an unmountable file system on an array disc. Running:
> >>
> >> xfs_repair -nv /dev/md3
> >
> > Did that find errors?
> >
> >> works, however when running
> >>
> >> xfs_repair -v /dev/md3
> >>
> >> it stops at "process newly discovered inodes..." and doesn't seem to be doing anything.
> >>
> >> I've asked in the unraid forum and they've directed me to the xfs mailing list.
> >>
> >> Appreciate any help.
> >
> > Please tell us the version of xfsprogs you're using, and provide the full xfs_repair
> > output (with and without -n).
> >
> > If it really looks like a bug, and not simply a slow repair, providing an xfs_metadump
> > may help us evaluate the problem further.
> >
> > -Eric
> >

-- 
Carlos Maiolino
