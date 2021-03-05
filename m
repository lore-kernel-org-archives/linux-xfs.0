Return-Path: <SRS0=x8pl=ID=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E3485C433DB
	for <linux-xfs@archiver.kernel.org>; Fri,  5 Mar 2021 14:42:14 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id B4ABF64F48
	for <linux-xfs@archiver.kernel.org>; Fri,  5 Mar 2021 14:42:14 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230525AbhCEOlm (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 5 Mar 2021 09:41:42 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36884 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230483AbhCEOli (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 5 Mar 2021 09:41:38 -0500
Received: from mail-pj1-x1029.google.com (mail-pj1-x1029.google.com [IPv6:2607:f8b0:4864:20::1029])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C36F0C061574;
        Fri,  5 Mar 2021 06:41:38 -0800 (PST)
Received: by mail-pj1-x1029.google.com with SMTP id bj7so2154460pjb.2;
        Fri, 05 Mar 2021 06:41:38 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=references:user-agent:from:to:cc:subject:in-reply-to:date
         :message-id:mime-version;
        bh=uCj+U2HAJu+eDN1VFgS16lbd/7PIRFkph4JwarceUBM=;
        b=lpn6x8pXCdhe7cX57at3i859Ndrt2dhFXpAL7szPv30mJ2yDHktt16eRC5kDBSDzDD
         fcVSFlF+OUqbCCV/gmZQrKFmEPGN+H6Ra+2tYsqAwtiIsXF5uhfhTjewf8jrW12fVdjG
         Gi4whZ/zZjaYD3xH6hzjU3gm4GW8wX9CwEAJITfWX3GvBY7Mk/FrCKTSkJiDdDNj9Zcc
         LQC1wD28JTuThQ5jbnVUGPMgiUI3+Cg2OO3cpFUI2Z60xwu6h8fPQZL6FaJ7JfFDLh5C
         9bPy7l0XogEcX52wP38ES2lCq6/5ZoeLavAWdlMzh74W6STBXb9g4vYtLVG4+goSa1MH
         +Wjw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:references:user-agent:from:to:cc:subject
         :in-reply-to:date:message-id:mime-version;
        bh=uCj+U2HAJu+eDN1VFgS16lbd/7PIRFkph4JwarceUBM=;
        b=aD4sFBJeqn2cSprTEfZqdkhM5vYN/9TpFBvnUYP/g2jDubKF7IdNy4jJYnYrv1uVe8
         FNdlUt9v+9jNgpX6PEX0Dye6hTc7JsarR+LAKSFq6zcntAetZCqBb97YU2nXrwcX8f0C
         Ie70VujOuL/C3ENP4USVqHL+gOCMjKFlD9UxVbucLrj59WYy9KUhvTKXUivGw9mfd/ai
         Luo84iDb6n3prmGc39I3V9vCEADL8sZxnBcm/4VnmcR6IkqBYpMXituN3s1sqRo3yGYx
         ISMPNotsAwCBpZOTLyb5tEDxPeFaPOqHbpLK9r6APS8M7eeAoQNMru9OzBLhKllk4GE+
         zJxA==
X-Gm-Message-State: AOAM533zXTyTofd82nNJnK8PA1XA9lT1PNd9H5oALpnnrKWfnAw3saab
        0wm2kXKeKehjBOUQ2K6nI+I=
X-Google-Smtp-Source: ABdhPJw52FPCjEhBdXXZkXHYa6wFr1/+Jv80TX3hHH1gl1S5Vl5WFT0LXdYuIJ7jU5rtGjnXtOvoSg==
X-Received: by 2002:a17:902:7e82:b029:e5:e936:664c with SMTP id z2-20020a1709027e82b02900e5e936664cmr4274727pla.10.1614955298394;
        Fri, 05 Mar 2021 06:41:38 -0800 (PST)
Received: from garuda ([122.171.172.255])
        by smtp.gmail.com with ESMTPSA id g6sm2841447pfi.15.2021.03.05.06.41.36
        (version=TLS1_2 cipher=ECDHE-ECDSA-CHACHA20-POLY1305 bits=256/256);
        Fri, 05 Mar 2021 06:41:38 -0800 (PST)
References: <20210118062022.15069-1-chandanrlinux@gmail.com> <20210118062022.15069-2-chandanrlinux@gmail.com> <20210303173050.GI7269@magnolia>
User-agent: mu4e 1.0; emacs 26.1
From:   Chandan Babu R <chandanrlinux@gmail.com>
To:     "Darrick J. Wong" <djwong@kernel.org>
Cc:     fstests@vger.kernel.org, linux-xfs@vger.kernel.org,
        darrick.wong@oracle.com
Subject: Re: [PATCH V4 01/11] common/xfs: Add a helper to get an inode fork's extent count
In-reply-to: <20210303173050.GI7269@magnolia>
Date:   Fri, 05 Mar 2021 20:11:35 +0530
Message-ID: <87im65u0gw.fsf@garuda>
MIME-Version: 1.0
Content-Type: text/plain
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On 03 Mar 2021 at 23:00, Darrick J. Wong wrote:
> On Mon, Jan 18, 2021 at 11:50:12AM +0530, Chandan Babu R wrote:
>> This commit adds the helper _scratch_get_iext_count() which returns an
>> inode fork's extent count.
>>
>> Signed-off-by: Chandan Babu R <chandanrlinux@gmail.com>
>> ---
>>  common/xfs | 22 ++++++++++++++++++++++
>>  1 file changed, 22 insertions(+)
>>
>> diff --git a/common/xfs b/common/xfs
>> index 3f5c14ba..641d6195 100644
>> --- a/common/xfs
>> +++ b/common/xfs
>> @@ -903,6 +903,28 @@ _scratch_get_bmx_prefix() {
>>  	return 1
>>  }
>>
>> +_scratch_get_iext_count()
>> +{
>> +	ino=$1
>> +	whichfork=$2
>
> Function variables should be declared with 'local' so they don't bleed
> into the global namespace (yay bash!), e.g.
>
> 	local ino="$1"

Sorry, I forgot about this. I will fix this up.

>
> Also, now that Eric has landed the xfs_db 'path' command upstream, you
> might consider using it:
>
> 	_scratch_xfs_get_metadata_field "core.nextents" "path /windows/system.ini"
>

In this patchset _scratch_get_iext_count() is being used to get extent counts
of anonymous inodes i.e. inodes which do not have an entry in the filesytem
namespace (e.g. Quota and RT bitmap/summary inodes). Hence the 'path' command
won't be useful in this case.

>> +
>> +	case $whichfork in
>> +		"attr")
>> +			field=core.naextents
>> +			;;
>> +		"data")
>> +			field=core.nextents
>> +			;;
>> +		*)
>> +			return 1
>> +	esac
>> +
>> +	nextents=$(_scratch_xfs_db  -c "inode $ino" -c "print $field")
>> +	nextents=${nextents##${field} = }
>
> _scratch_xfs_get_metadata_field?

Sure, I will make use of the above mentioned helper.

--
chandan
