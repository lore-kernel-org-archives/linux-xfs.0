Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-17.5 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,NICE_REPLY_A,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E91C2C433DB
	for <linux-xfs@archiver.kernel.org>; Thu, 28 Jan 2021 22:01:01 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id B601064DEC
	for <linux-xfs@archiver.kernel.org>; Thu, 28 Jan 2021 22:01:01 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229819AbhA1WBA (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 28 Jan 2021 17:01:00 -0500
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:48504 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229596AbhA1WA6 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 28 Jan 2021 17:00:58 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1611871171;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=2+n9KMYp2eyNDjXRQLIaDFjeyEVc/wh325iAQlQ+4qE=;
        b=Gp+tu+7RXzOQBB50NuzyFOF2dHMdndNcnbokNO6o39ZacAzv1mZEve5EpnswWaPD7IGR3+
        0yDXMap37YZ4aTwHSEA7R00S0rZD18x+9CtaFQJwviVdIzwB9QR8abROxX78u3q9iL6iZA
        jzKQS75QT9Ahjm5sL3yfucH+PxTqt0c=
Received: from mail-pl1-f198.google.com (mail-pl1-f198.google.com
 [209.85.214.198]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-225-Yo1SzxO1Pm2LUZyYiclj8g-1; Thu, 28 Jan 2021 16:59:29 -0500
X-MC-Unique: Yo1SzxO1Pm2LUZyYiclj8g-1
Received: by mail-pl1-f198.google.com with SMTP id e12so416160plh.2
        for <linux-xfs@vger.kernel.org>; Thu, 28 Jan 2021 13:59:29 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=2+n9KMYp2eyNDjXRQLIaDFjeyEVc/wh325iAQlQ+4qE=;
        b=TtLqrZZrWHf/7iOiQ9VojDhPWFpmUQwSRRWYKhPwX+ZchF2Lwn/B01UdSvv/8Ak/fc
         4WBXjm3fA/3kFBkx72QtabGDrfwJeq3iC63n3U/9KtU3lYZxQXpnpaqO1gDkRBzozcYD
         h6HbxBXl8Vm+IafohQpmQJU84W3KrGZtBampKF/gjzOFuMdcu8ghN62xMNHem+AzDKWo
         bwc22vRrIT0X366Mi/XRbM8AUexliatILj8eO22nvTw/c2yeyl7jcbIbleokzKAE4cR7
         McUHfBE9CV2urfKVpUeDyoGsNIagfVwfq60Cd+lwSHgCK5N8Jy925J5qex17ytHhMK2K
         RP2g==
X-Gm-Message-State: AOAM533zaOIDWCKNn3IGH2EBdWdJAAUshENKSzsP7VDzO0C5q6dJEswF
        oevGTGXXKX8w74tANAaoYFALUeBOkrjxzwkco0hfESpMaf7lo8kXQP27KjnPgmCXBLg5Xo1EFV6
        FU4YDDKzLFFI8T+Zr9y4LhZQj5UZhLbPo4BevJdDs48eQY3ad5N6pEUOQYtjs5JCClY6Fw1Y6
X-Received: by 2002:a63:5b43:: with SMTP id l3mr1363718pgm.369.1611871168292;
        Thu, 28 Jan 2021 13:59:28 -0800 (PST)
X-Google-Smtp-Source: ABdhPJyZPMAsWMbgdL0e2KxT6XVIq3i5AGlJskS3aZrOeKtEJkoWerPeO5eH6rW8CXHx31dgNXsRyA==
X-Received: by 2002:a63:5b43:: with SMTP id l3mr1363699pgm.369.1611871167988;
        Thu, 28 Jan 2021 13:59:27 -0800 (PST)
Received: from ?IPv6:2001:8003:4800:1b00:4c4a:1757:c744:923? ([2001:8003:4800:1b00:4c4a:1757:c744:923])
        by smtp.gmail.com with ESMTPSA id s23sm6882675pgj.29.2021.01.28.13.59.25
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 28 Jan 2021 13:59:27 -0800 (PST)
Subject: Re: [PATCH 2/2] xfs_logprint: decode superblock updates correctly
To:     "Darrick J. Wong" <djwong@kernel.org>
Cc:     linux-xfs@vger.kernel.org
References: <20210128073708.25572-1-ddouwsma@redhat.com>
 <20210128073708.25572-3-ddouwsma@redhat.com> <20210128172828.GP7698@magnolia>
From:   Donald Douwsma <ddouwsma@redhat.com>
Message-ID: <1e5bc8ef-26f9-3189-e08f-55fd12976c09@redhat.com>
Date:   Fri, 29 Jan 2021 08:59:23 +1100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.6.1
MIME-Version: 1.0
In-Reply-To: <20210128172828.GP7698@magnolia>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org



On 29/01/2021 04:28, Darrick J. Wong wrote:
> On Thu, Jan 28, 2021 at 06:37:08PM +1100, Donald Douwsma wrote:
>> Back when the way superblocks are logged changed, logprint wasnt
>> updated updated. Currently logprint displays incorrect accounting
> 
> Double 'updated'.

Oops

> 
>> information.
>>
>>  SUPER BLOCK Buffer:
>>  icount: 6360863066640355328  ifree: 262144  fdblks: 0  frext: 0
>>
>>  $ printf "0x%x\n" 6360863066640355328
>>  0x5846534200001000
>>
>> Part of this decodes as 'XFSB', the xfs superblock magic number and not
>> the free space accounting.
>>
>> Fix this by looking at the entire superblock buffer and using the format
>> structure as is done for the other allocation group headers.
>>
>> Signed-off-by: Donald Douwsma <ddouwsma@redhat.com>
>> ---
>>  logprint/log_misc.c      | 22 +++++++++-------------
>>  logprint/log_print_all.c | 23 ++++++++++-------------
>>  2 files changed, 19 insertions(+), 26 deletions(-)
>>
>> diff --git a/logprint/log_misc.c b/logprint/log_misc.c
>> index d44e9ff7..929842d0 100644
>> --- a/logprint/log_misc.c
>> +++ b/logprint/log_misc.c
>> @@ -243,25 +243,21 @@ xlog_print_trans_buffer(char **ptr, int len, int *i, int num_ops)
>>  	xlog_print_op_header(head, *i, ptr);
>>  	if (super_block) {
>>  		printf(_("SUPER BLOCK Buffer: "));
>> -		if (be32_to_cpu(head->oh_len) < 4*8) {
>> +		if (be32_to_cpu(head->oh_len) < sizeof(struct xfs_sb)) {
>>  			printf(_("Out of space\n"));
>>  		} else {
>> -			__be64		 a, b;
>> +			struct xfs_sb *sb, sb_s;
>>  
>>  			printf("\n");
>> -			/*
>> -			 * memmove because *ptr may not be 8-byte aligned
>> -			 */
>> -			memmove(&a, *ptr, sizeof(__be64));
>> -			memmove(&b, *ptr+8, sizeof(__be64));
>> +			/* memmove because *ptr may not be 8-byte aligned */
>> +			sb = &sb_s;
>> +			memmove(sb, *ptr, sizeof(struct xfs_sb));
>>  			printf(_("icount: %llu  ifree: %llu  "),
>> -			       (unsigned long long) be64_to_cpu(a),
>> -			       (unsigned long long) be64_to_cpu(b));
>> -			memmove(&a, *ptr+16, sizeof(__be64));
>> -			memmove(&b, *ptr+24, sizeof(__be64));
>> +				be64_to_cpu(sb->sb_icount),
>> +				be64_to_cpu(sb->sb_ifree) );
> 
> Extra space at the end ..................................^

ack

> 
>>  			printf(_("fdblks: %llu  frext: %llu\n"),
>> -			       (unsigned long long) be64_to_cpu(a),
>> -			       (unsigned long long) be64_to_cpu(b));
>> +				be64_to_cpu(sb->sb_fdblocks),
>> +				be64_to_cpu(sb->sb_frextents));
>>  		}
>>  		super_block = 0;
>>  	} else if (be32_to_cpu(*(__be32 *)(*ptr)) == XFS_AGI_MAGIC) {
>> diff --git a/logprint/log_print_all.c b/logprint/log_print_all.c
>> index 2b9e810d..8ff87068 100644
>> --- a/logprint/log_print_all.c
>> +++ b/logprint/log_print_all.c
>> @@ -91,22 +91,19 @@ xlog_recover_print_buffer(
>>  		len = item->ri_buf[i].i_len;
>>  		i++;
>>  		if (blkno == 0) { /* super block */
>> -			printf(_("	SUPER Block Buffer:\n"));
>> +                        struct xfs_sb *sb = (struct xfs_sb *)p;
>> +			printf(_("	Super Block Buffer: (XFSB)\n"));
>>  			if (!print_buffer)
>>  				continue;
>> -		       printf(_("              icount:%llu ifree:%llu  "),
>> -			       (unsigned long long)
>> -				       be64_to_cpu(*(__be64 *)(p)),
>> -			       (unsigned long long)
>> -				       be64_to_cpu(*(__be64 *)(p+8)));
>> -		       printf(_("fdblks:%llu  frext:%llu\n"),
>> -			       (unsigned long long)
>> -				       be64_to_cpu(*(__be64 *)(p+16)),
>> -			       (unsigned long long)
>> -				       be64_to_cpu(*(__be64 *)(p+24)));
>> +			printf(_("		icount:%llu  ifree:%llu  "),
>> +					be64_to_cpu(sb->sb_icount),
>> +					be64_to_cpu(sb->sb_ifree));
>> +			printf(_("fdblks:%llu  frext:%llu\n"),
>> +					be64_to_cpu(sb->sb_fdblocks),
>> +					be64_to_cpu(sb->sb_frextents));
>>  			printf(_("		sunit:%u  swidth:%u\n"),
>> -			       be32_to_cpu(*(__be32 *)(p+56)),
>> -			       be32_to_cpu(*(__be32 *)(p+60)));
>> +			       be32_to_cpu(sb->sb_unit),
>> +			       be32_to_cpu(sb->sb_width));
> 
> /me wonders if these nearly identical decoder routines ought to be
> refactored into a common helper?

log_print_all.c seems to be coupled to the log recovery code in libxfs when
-t is used, but xfs_log_misc.c does its own thing to decode the records 
outside of recovery. Its a bit messy.

> 
> Also, what happens if logprint encounters a log from before whenever we
> changed superblock encoding in the log?  When was that, anyway?

... um bad things, it will dump information from further along in the log, 
possibly beyond the end of the buffer and crash. 

I _think_ it was when lazy superblock updates went in, tracking that down
would be a better way to work out how to handle this, I'll do some research.

> 
> --D
> 
>>  		} else if (be32_to_cpu(*(__be32 *)p) == XFS_AGI_MAGIC) {
>>  			int bucket, buckets;
>>  			agi = (xfs_agi_t *)p;
>> -- 
>> 2.27.0
>>
> 

