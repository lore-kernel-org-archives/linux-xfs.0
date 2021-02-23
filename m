Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-17.3 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,NICE_REPLY_A,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DC438C433E0
	for <linux-xfs@archiver.kernel.org>; Tue, 23 Feb 2021 17:55:08 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 997AC64E85
	for <linux-xfs@archiver.kernel.org>; Tue, 23 Feb 2021 17:55:08 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232443AbhBWRzH (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 23 Feb 2021 12:55:07 -0500
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:59704 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S232340AbhBWRzH (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 23 Feb 2021 12:55:07 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1614102820;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=HdmBBRIhtfvWBHI1OEIREkfJ2O9ZZQocM7OsnkwH8Mw=;
        b=UmjFE9as5sxNf4Wxa8ZJpYE5RQYi3TF1Q4tCoTRBZ9J98bE5yYCYI946+Ml/cux9KTUikd
        nsMwCMGDkdeVEEgoCpFGYByoJRr4/RVeyQZrYhAgHQGBwKRPG6nlcJmt/rY/0nkz/SEiae
        C3HrRam+Uwc91rbHQuvdHFYjt9d5PvM=
Received: from mail-wr1-f71.google.com (mail-wr1-f71.google.com
 [209.85.221.71]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-341-vradmhuXPM-JzU2h6HB6FQ-1; Tue, 23 Feb 2021 12:53:38 -0500
X-MC-Unique: vradmhuXPM-JzU2h6HB6FQ-1
Received: by mail-wr1-f71.google.com with SMTP id e29so7459664wra.12
        for <linux-xfs@vger.kernel.org>; Tue, 23 Feb 2021 09:53:37 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=HdmBBRIhtfvWBHI1OEIREkfJ2O9ZZQocM7OsnkwH8Mw=;
        b=AW6C8eNJAxKdTBBDlRD9+gZIW+Xr+XHq3Ulq/5OWlRNoCEYEF6nI/n/2NUKc/AOsFn
         rmaTIZiI9XrwUmmGuON8SNEpleloSmi3nBlnwbFLIWOhKhOQL/XvLClyqo5NCBK+yqsR
         GEMbAm/F91XPhrqw0Xb+ffMioYqcRamhyQGMOrqeMbSQw2TU1J4+/TgH1NwNozKFKP/g
         9PrtBWk6ZQcHB316Ea/ylJwBcaorMbAdGPelx64Oeaksn90u/Z4/is0OEj/ygX2jGqwn
         hvVb76cdw0ApiuxhyNkGcKXhku2ws+YLFP799R9DHKiQ1D6n+XXM7pwcXZjh97T/Rd7h
         UHzw==
X-Gm-Message-State: AOAM532qpEsWyWrvJO76yRzlLXcqjcYafCos8wIus+lFWmvFQtBynghq
        hk4DZRWPxwyG1VfJjya/kWQ1IA6bPOriPM3e6WRFntNG6T85WpL4jfQWJuPomQ32FQSVeauZITY
        cDwQL0JjfTMbfxvtEbAkkfX4d9rYIUqZUQ3I6uySuL/vJPejMBt/Q/dAk+GCkW7RPGzP4IGo=
X-Received: by 2002:adf:c101:: with SMTP id r1mr27784253wre.38.1614102815868;
        Tue, 23 Feb 2021 09:53:35 -0800 (PST)
X-Google-Smtp-Source: ABdhPJwyrMUIJFyCSMd22I2baGi16ZPohvWQBZ36GkZM2VLNSceHqfuwhWhGYq3q5Hb4Nw5v+gDc2w==
X-Received: by 2002:adf:c101:: with SMTP id r1mr27784236wre.38.1614102815603;
        Tue, 23 Feb 2021 09:53:35 -0800 (PST)
Received: from localhost.localdomain ([84.19.91.9])
        by smtp.gmail.com with ESMTPSA id n10sm6460486wrt.83.2021.02.23.09.53.34
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 23 Feb 2021 09:53:35 -0800 (PST)
Subject: Re: [PATCH 1/1] xfs: Skip repetitive warnings about mount options
To:     Eric Sandeen <sandeen@sandeen.net>, linux-xfs@vger.kernel.org
References: <20210220221549.290538-1-preichl@redhat.com>
 <20210220221549.290538-3-preichl@redhat.com>
 <61f66b91-4343-f28e-dd47-6b6c70ee8b96@sandeen.net>
From:   Pavel Reichl <preichl@redhat.com>
Message-ID: <e29b3877-385b-3e0a-5761-51bb1265b302@redhat.com>
Date:   Tue, 23 Feb 2021 18:53:34 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.7.0
MIME-Version: 1.0
In-Reply-To: <61f66b91-4343-f28e-dd47-6b6c70ee8b96@sandeen.net>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org



On 2/22/21 11:19 PM, Eric Sandeen wrote:
> 
> On 2/20/21 4:15 PM, Pavel Reichl wrote:
>> Skip the warnings about mount option being deprecated if we are
>> remounting and deprecated option state is not changing.
>>
>> Bug: https://bugzilla.kernel.org/show_bug.cgi?id=211605
>> Fix-suggested-by: Eric Sandeen <sandeen@redhat.com>
>> Signed-off-by: Pavel Reichl <preichl@redhat.com>
>> ---
>>  fs/xfs/xfs_super.c | 23 +++++++++++++++++++----
>>  1 file changed, 19 insertions(+), 4 deletions(-)
>>
>> diff --git a/fs/xfs/xfs_super.c b/fs/xfs/xfs_super.c
>> index 813be879a5e5..6724a7018d1f 100644
>> --- a/fs/xfs/xfs_super.c
>> +++ b/fs/xfs/xfs_super.c
>> @@ -1169,6 +1169,13 @@ xfs_fs_parse_param(
>>  	struct fs_parse_result	result;
>>  	int			size = 0;
>>  	int			opt;
>> +	uint64_t                prev_m_flags = 0; /* Mount flags of prev. mount */
>> +	bool			remounting = fc->purpose & FS_CONTEXT_FOR_RECONFIGURE;
>> +
>> +	/* if reconfiguring then get mount flags of previous flags */
>> +	if (remounting) {
>> +		prev_m_flags  = XFS_M(fc->root->d_sb)->m_flags;
> 
> I wonder, does mp->m_flags work just as well for this purpose? I do get lost
> in how the mount api stashes things. I /think/ that the above is just a
> long way of getting to mp->m_flags.

Hi Eric, I'm sorry to disagree, but I think that mp->m_flags is newly allocated for this mount and it's not populated with previous mount's mount options.

static int xfs_init_fs_context(
        struct fs_context       *fc)
{
        struct xfs_mount        *mp;

So here it's allocated and zeroed

        mp = kmem_alloc(sizeof(struct xfs_mount), KM_ZERO);
        if (!mp)
                return -ENOMEM;
                
...

a few flags are set by values from super block, but not nearly all of them

        /*
         * Copy binary VFS mount flags we are interested in.
         */
        if (fc->sb_flags & SB_RDONLY)
                mp->m_flags |= XFS_MOUNT_RDONLY;
        if (fc->sb_flags & SB_DIRSYNC)
                mp->m_flags |= XFS_MOUNT_DIRSYNC;
        if (fc->sb_flags & SB_SYNCHRONOUS)
                mp->m_flags |= XFS_MOUNT_WSYNC;

here it's assigned

        fc->s_fs_info = mp;

...

> 
>> +	}
>>  
>>  	opt = fs_parse(fc, xfs_fs_parameters, param, &result);
>>  	if (opt < 0)
>> @@ -1294,19 +1301,27 @@ xfs_fs_parse_param(
>>  #endif
>>  	/* Following mount options will be removed in September 2025 */
>>  	case Opt_ikeep:
>> -		xfs_warn(mp, "%s mount option is deprecated.", param->key);
>> +		if (!remounting ||  !(prev_m_flags & XFS_MOUNT_IKEEP)) {
> 
> while we're nitpicking whitespace, ^^ 2 spaces there
> 
> as for the prev_m_flags usage, does:
> 
> +		if (!remounting || !(mp->m_flags & XFS_MOUNT_IKEEP)) {
> 
> work just as well here or no?

I don't think so - while developing the path I printk-ed  the value and it did not reflect the mount options of previous mount...IIRC we discussed it and you hinted me to use the XFS_M(fc->root->d_sb)->m_flags...which works.

So I'm a bit confused by your comment, but I get confused a lot :-)

> 
>> +			xfs_warn(mp, "%s mount option is deprecated.", param->key);
>> +		}
>>  		mp->m_flags |= XFS_MOUNT_IKEEP;
>>  		return 0;
>>  	case Opt_noikeep:
>> -		xfs_warn(mp, "%s mount option is deprecated.", param->key);
>> +		if (!remounting || prev_m_flags & XFS_MOUNT_IKEEP) {
> 
> and I dunno, I think I'd like parentheses for clarity here i.e.:
> 
> +		if (!remounting || (prev_m_flags & XFS_MOUNT_IKEEP)) {
> 
> Thanks,
> -Eric
> 
> 
>> +			xfs_warn(mp, "%s mount option is deprecated.", param->key);
>> +		}
>>  		mp->m_flags &= ~XFS_MOUNT_IKEEP;
>>  		return 0;
>>  	case Opt_attr2:
>> -		xfs_warn(mp, "%s mount option is deprecated.", param->key);
>> +		if (!remounting || !(prev_m_flags & XFS_MOUNT_ATTR2)) {
>> +			xfs_warn(mp, "%s mount option is deprecated.", param->key);
>> +		}
>>  		mp->m_flags |= XFS_MOUNT_ATTR2;
>>  		return 0;
>>  	case Opt_noattr2:
>> -		xfs_warn(mp, "%s mount option is deprecated.", param->key);
>> +		if (!remounting || !(prev_m_flags & XFS_MOUNT_NOATTR2)) {
>> +			xfs_warn(mp, "%s mount option is deprecated.", param->key);
>> +		}
>>  		mp->m_flags &= ~XFS_MOUNT_ATTR2;
>>  		mp->m_flags |= XFS_MOUNT_NOATTR2;
>>  		return 0;
>>
> 

