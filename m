Return-Path: <SRS0=lRpT=32=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.9 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D1481C2D0B1
	for <linux-xfs@archiver.kernel.org>; Thu,  6 Feb 2020 14:35:42 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id A647F217BA
	for <linux-xfs@archiver.kernel.org>; Thu,  6 Feb 2020 14:35:42 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="NZeY3KO8"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728071AbgBFOfm (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 6 Feb 2020 09:35:42 -0500
Received: from us-smtp-delivery-1.mimecast.com ([207.211.31.120]:57186 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1727918AbgBFOfm (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 6 Feb 2020 09:35:42 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1580999741;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=qttFRxOZZqx+r0Bk1kgnDygwg7qvJj32AfnURV7qM28=;
        b=NZeY3KO8V/lAlz1xdYFDCA7gtgZfj7giclK2K1ZOq67LeU/vFjxsXaIovM6m2c2NTIT45D
        8HSSpbicKxbs73C3IPHVYc91au7MxgvYb8wRHk1Z/9vlEmMFcwZ7givENzGdsUcAajk57i
        vztpVVHTj91pVbW1TfRpqqPHNTZg78Y=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-367-QgsrF0W2ObWhqYl32dv4nw-1; Thu, 06 Feb 2020 09:35:39 -0500
X-MC-Unique: QgsrF0W2ObWhqYl32dv4nw-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com [10.5.11.23])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 94145185734C;
        Thu,  6 Feb 2020 14:35:38 +0000 (UTC)
Received: from segfault.boston.devel.redhat.com (segfault.boston.devel.redhat.com [10.19.60.26])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 24AFA26E43;
        Thu,  6 Feb 2020 14:35:38 +0000 (UTC)
From:   Jeff Moyer <jmoyer@redhat.com>
To:     zlang@redhat.com, linux-xfs@vger.kernel.org
Cc:     fstests@vger.kernel.org
Subject: Re: [PATCH 1/3] dax/dm: disable testing on devices that don't support dax
References: <20200205224818.18707-1-jmoyer@redhat.com>
        <20200205224818.18707-2-jmoyer@redhat.com>
        <20200206050821.GT14282@dhcp-12-102.nay.redhat.com>
X-PGP-KeyID: 1F78E1B4
X-PGP-CertKey: F6FE 280D 8293 F72C 65FD  5A58 1FF8 A7CA 1F78 E1B4
Date:   Thu, 06 Feb 2020 09:35:37 -0500
In-Reply-To: <20200206050821.GT14282@dhcp-12-102.nay.redhat.com> (Zorro Lang's
        message of "Thu, 6 Feb 2020 13:08:21 +0800")
Message-ID: <x49pnerlr5y.fsf@segfault.boston.devel.redhat.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/26.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.23
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Zorro Lang <zlang@redhat.com> writes:

> On Wed, Feb 05, 2020 at 05:48:16PM -0500, Jeff Moyer wrote:
>> Move the hack out of dmflakey and put it into _require_dm_target.  This
>> fixes up a lot of missed tests that are failing due to the lack of dax
>> support (such as tests on dm-thin, snapshot, etc).
>> 
>> Signed-off-by: Jeff Moyer <jmoyer@redhat.com>
>> ---
>>  common/dmflakey |  5 -----
>>  common/rc       | 11 +++++++++++
>>  2 files changed, 11 insertions(+), 5 deletions(-)
>> 
>> diff --git a/common/dmflakey b/common/dmflakey
>> index 2af3924d..b4e11ae9 100644
>> --- a/common/dmflakey
>> +++ b/common/dmflakey
>> @@ -8,11 +8,6 @@ FLAKEY_ALLOW_WRITES=0
>>  FLAKEY_DROP_WRITES=1
>>  FLAKEY_ERROR_WRITES=2
>>  
>> -echo $MOUNT_OPTIONS | grep -q dax
>> -if [ $? -eq 0 ]; then
>> -	_notrun "Cannot run tests with DAX on dmflakey devices"
>> -fi
>
> If we need to remove this for common/dmflakey, why not do the same thing
> in common/dmthin and common/dmdelay etc ?

I didn't realize they had this same code.  I'll make that change,
thanks!

-Jeff

>
>> -
>>  _init_flakey()
>>  {
>>  	local BLK_DEV_SIZE=`blockdev --getsz $SCRATCH_DEV`
>> diff --git a/common/rc b/common/rc
>> index eeac1355..785f34c6 100644
>> --- a/common/rc
>> +++ b/common/rc
>> @@ -1874,6 +1874,17 @@ _require_dm_target()
>>  	_require_sane_bdev_flush $SCRATCH_DEV
>>  	_require_command "$DMSETUP_PROG" dmsetup
>>  
>> +	echo $MOUNT_OPTIONS | grep -q dax
>> +	if [ $? -eq 0 ]; then
>> +		case $target in
>> +		stripe|linear|error)
>> +			;;
>> +		*)
>> +			_notrun "Cannot run tests with DAX on $target devices."
>> +			;;
>> +		esac
>> +	fi
>> +
>>  	modprobe dm-$target >/dev/null 2>&1
>>  
>>  	$DMSETUP_PROG targets 2>&1 | grep -q ^$target
>> -- 
>> 2.19.1
>> 

