Return-Path: <SRS0=2cgH=B3=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.9 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A0D17C433DF
	for <linux-xfs@archiver.kernel.org>; Mon, 17 Aug 2020 06:25:19 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 814EB207DF
	for <linux-xfs@archiver.kernel.org>; Mon, 17 Aug 2020 06:25:19 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="OpcRCogL"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726530AbgHQGZT (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 17 Aug 2020 02:25:19 -0400
Received: from us-smtp-2.mimecast.com ([207.211.31.81]:26353 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726385AbgHQGZR (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 17 Aug 2020 02:25:17 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1597645515;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=kNK13pw2n80PSTIyJ5Y1JSY7kD+TGm3CPnZRTIZW3l4=;
        b=OpcRCogLReDaAfrKSqUqdxg10l7bPur5OPQWKtSclmq1GDDeeGo5jA7R4f5C8Xo6FvrJIp
        AvYJDk/bY9d0wo+aLUikUp3UBGOzK6FQxTGrp0vBkW8VWayxsAthBtwDDfWUVKImutpuqW
        vCXBCrAn46M8WtuaihV9c858r9WKvmQ=
Received: from mail-pf1-f198.google.com (mail-pf1-f198.google.com
 [209.85.210.198]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-413-4sGkMnwdMTCb9fcCASfDlg-1; Mon, 17 Aug 2020 02:25:13 -0400
X-MC-Unique: 4sGkMnwdMTCb9fcCASfDlg-1
Received: by mail-pf1-f198.google.com with SMTP id z16so10228821pfq.7
        for <linux-xfs@vger.kernel.org>; Sun, 16 Aug 2020 23:25:13 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:references:from:cc:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=kNK13pw2n80PSTIyJ5Y1JSY7kD+TGm3CPnZRTIZW3l4=;
        b=SclbOR6jHuk+e2zA1kWVVnw61WSufeZMbFPQ5cB0+Hd599Hmo79f6mdll9DIMg9URS
         /lFu+FL6JvuMasswIfvifx8kd1iISRtZS9uPT0+f0p+A3L4QT+/UkI9n2KlkWYidzv5g
         uxAbKmWn4Jj6naUnBSm07ykiB/8IxV9I/XUcJX1qdPZULl3rlNrypwff2yEKSF6uO9ap
         ov86VgKTYUlae9GbDacShNbsGjFHqUCz90zE+wZyrtzEhZxm4E/t/VO+FQ78q8VdXqSP
         /1TAG4lYkGCl+j7CIyyb+GzjTTFmkgLNSDGKXQnTVzSLZg41G4F/82dSUcq5Yfda+s+5
         HTow==
X-Gm-Message-State: AOAM533wWxacFVC1ffym6ywtil88MWrprKNEH5n/iYNrNcDBN+Nq9r+o
        b/RtGXySD4p1Lu2rjQzjKuuIgBCXo+L/u9wOzLZYzigGrn68boQTAjJMPJGTtxVyBbmdPeKsG+m
        NGbwD0D8FkKLTZeEYlaU+
X-Received: by 2002:a17:90a:6d26:: with SMTP id z35mr11067188pjj.164.1597645512467;
        Sun, 16 Aug 2020 23:25:12 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJw+HQK2siOQLS6SpT0+qEl/ToqxxwDztIZpjuJlXULkDqpvOBfSFHPtlb5fz89n406d5qcC9w==
X-Received: by 2002:a17:90a:6d26:: with SMTP id z35mr11067174pjj.164.1597645512197;
        Sun, 16 Aug 2020 23:25:12 -0700 (PDT)
Received: from don.don ([60.224.129.195])
        by smtp.gmail.com with ESMTPSA id o4sm16312037pjs.51.2020.08.16.23.25.09
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 16 Aug 2020 23:25:11 -0700 (PDT)
Subject: Re: [PATCH v2] xfstests: add test for xfs_repair progress reporting
To:     linux-xfs@vger.kernel.org, fstests@vger.kernel.org
References: <20200519160125.GB17621@magnolia>
 <20200520035258.298516-1-ddouwsma@redhat.com>
 <20200529080640.GH1938@dhcp-12-102.nay.redhat.com>
 <3097a996-c661-d03f-a3e6-aa60ea808f04@redhat.com>
 <41124f57-55e6-68c4-ef90-b51fc5e3b68f@redhat.com>
 <20200611050345.GL1938@dhcp-12-102.nay.redhat.com>
From:   Donald Douwsma <ddouwsma@redhat.com>
Cc:     Zorro Lang <zlang@redhat.com>
Message-ID: <8faba9f9-cecb-59c2-a89c-1484a95340bd@redhat.com>
Date:   Mon, 17 Aug 2020 16:25:07 +1000
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.9.0
MIME-Version: 1.0
In-Reply-To: <20200611050345.GL1938@dhcp-12-102.nay.redhat.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Hi Zorry, 

On 11/06/2020 15:03, Zorro Lang wrote:
> On Mon, Jun 01, 2020 at 01:55:49PM +1000, Donald Douwsma wrote:
>>
>>
>> On 01/06/2020 10:53, Donald Douwsma wrote:
>>> Hi Zorro,
>>>
>>> On 29/05/2020 18:06, Zorro Lang wrote:
>>>> On Wed, May 20, 2020 at 01:52:58PM +1000, Donald Douwsma wrote:
>>
>> <snip>
>>
>>>>> --- a/tests/xfs/group
>>>>> +++ b/tests/xfs/group
>>>>> @@ -513,3 +513,4 @@
>>>>>  513 auto mount
>>>>>  514 auto quick db
>>>>>  515 auto quick quota
>>>>> +516 repair
>>>>
>>>> Is there a reason why this case shouldn't be in auto group?
>>>>
>>>> Thanks,
>>>> Zorro
>>>
>>>
>>> We could work to wards getting it into auto, I wanted to make sure it
>>> was working ok first.
> 
> I just rechecked the mail list, sorry I missed this email long time (CC me will
> make sure I won't miss it next time:)

Will do,

> I think several minutes running time is acceptable to be into auto group, if the
> case is stable enough, won't fail unexpected.

Ok, I'll submit with it added to the auto group as well. 

 
>>>
>>> It takes about 2.5 min to run with the current image used by
>>> _scratch_populate_cached, by its nature it needs time for the progress
>>> code to fire, but that may be ok.
>>>
>>> It sometimes leaves the delay-test active, I think because I've I used
>>> _dmsetup_remove in _cleanup instead of _cleanup_delay because the later
>>> unmounts the filesystem, which this test doesnt do, but I'd have to look
>>> into this more so it plays well with other tests like the original
>>> dmdelay unmount test 311.
>>
>> Actually it does clean up delay-test correctly (*cough* I may have been
>> backgrounding xfs_repair in my xfstests tree while testing something
>> else).  I have seen it leave delay-test around if terminated with 
>> ctrl+c, but that seems reasonable if a test is aborted. 
> 
> If use a common helper to DO a test, I'd like to use its corresponding
> helper to cleanup UNDO it. If there's still something wrong, we can fix the
> helpers.
> 
>>
>>> I wasn't completely happy with the filter, it only checks that any of the
>>> progress messages are printing at least once, which for most can still
>>> just match on the end of phase printing, which always worked. Ideally it
>>> would check that some of these messages print multiple times.
>>>
>>> I can work on a V3 if this hasn't merged yet, or a follow up after, thoughts?
> 
> Sure, hope the V3 can improve the output mismatch issue, although the filter is
> really boring:)

I think boring may be safer if its going into the auto group.

I'd like to stick with the boring filter to start with, I dont want to make it
too fragile if the image changes. 

>>>
>>
>>
> 

