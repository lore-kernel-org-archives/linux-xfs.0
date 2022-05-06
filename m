Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 23621C433FE
	for <linux-xfs@archiver.kernel.org>; Fri,  6 May 2022 16:54:59 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1443976AbiEFQ6k (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 6 May 2022 12:58:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59198 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1443981AbiEFQ6j (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 6 May 2022 12:58:39 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id BB0A86D4E4
        for <linux-xfs@vger.kernel.org>; Fri,  6 May 2022 09:54:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1651856089;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=ZgnGPmAuCCp5/kwe2ntO3QR2/oGYqKS4vz26F4+mpDs=;
        b=iGHXULIITPDtU5f8psOGtGQxqjIJBgB/zv5WCCHEtFLc23zl9FP1t67SgSICZLUJnmuvLJ
        f3d+JU6qFT8lv9OLojP8g5llpmGYBlCLoPQSpkKqSG28RYbz/UJpBgC/AgkG54C2Cvm5Fx
        vllZz05ddQ+mUQAi1P2dvpwQG/NCVE0=
Received: from mail-qk1-f197.google.com (mail-qk1-f197.google.com
 [209.85.222.197]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-450-p7kmw8boMh6WkzqGBY9YRg-1; Fri, 06 May 2022 12:54:48 -0400
X-MC-Unique: p7kmw8boMh6WkzqGBY9YRg-1
Received: by mail-qk1-f197.google.com with SMTP id s63-20020a372c42000000b0069ec0715d5eso5325065qkh.10
        for <linux-xfs@vger.kernel.org>; Fri, 06 May 2022 09:54:48 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id
         :mail-followup-to:references:mime-version:content-disposition
         :in-reply-to;
        bh=ZgnGPmAuCCp5/kwe2ntO3QR2/oGYqKS4vz26F4+mpDs=;
        b=vYlULJvoW+u5srSiJimLAvM1+2EsOdGbR4bhB2nWBwA5buT9oVmuCLrlOwwkM2o+0R
         e68HDEtkUVeryX3CEXxkoP9UDGHR14oBZ6ailOxKqZexdaYqEYVjDyQeVozW5DLSBEhy
         byWN0SSZWpu8Ng1GdjERw8uq7YM4AIInWvL6R+gdEY3KicORRpxS1mLl2hxn5labgrN8
         OpnG6XzEwdFVEr6LK+KiAycyKaJ8kodv3gJFmsNy+zM1LWm5MqBc1tAq6Krg1yRRSiL0
         K4ga/sYa6mG57eRHX5sG8XZp89tG/k5crsJ32zs32uYWq0ht1xt5jn6rjw78+4+/aBW+
         mzKw==
X-Gm-Message-State: AOAM533+o8TuPjiZMGzyyIoA1B2MN6NcCElugajO2xFeVkJwZXuMwmXM
        JGPpWqVXXO01Fvugg77rdDGWwEFga85ngvoT3kKYSQX/uTJYoDBtinF1W7B4sOpFa5eNJBCcwfe
        frpnydGsXjy8pSTf1gIjA
X-Received: by 2002:a05:6214:f26:b0:458:3341:3a81 with SMTP id iw6-20020a0562140f2600b0045833413a81mr3271142qvb.112.1651856087628;
        Fri, 06 May 2022 09:54:47 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJwMbNSn0c18VRJCO5aOMfHD496Lh+5UDhycp2p5wfP1CAdh/Tff3ZriVXUpYPQ+reM9VV3MwQ==
X-Received: by 2002:a05:6214:f26:b0:458:3341:3a81 with SMTP id iw6-20020a0562140f2600b0045833413a81mr3271116qvb.112.1651856087311;
        Fri, 06 May 2022 09:54:47 -0700 (PDT)
Received: from zlang-mailbox ([209.132.188.80])
        by smtp.gmail.com with ESMTPSA id m2-20020ae9e702000000b0069fc7108dcesm2699975qka.61.2022.05.06.09.54.44
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 06 May 2022 09:54:46 -0700 (PDT)
Date:   Sat, 7 May 2022 00:54:41 +0800
From:   Zorro Lang <zlang@redhat.com>
To:     "Darrick J. Wong" <djwong@kernel.org>
Cc:     Zorro Lang <zlang@kernel.org>, fstests@vger.kernel.org,
        linux-xfs@vger.kernel.org
Subject: Re: [PATCH] generic: soft quota limits testing within grace time
Message-ID: <20220506165441.3elwulgaipfdpruu@zlang-mailbox>
Mail-Followup-To: "Darrick J. Wong" <djwong@kernel.org>,
        Zorro Lang <zlang@kernel.org>, fstests@vger.kernel.org,
        linux-xfs@vger.kernel.org
References: <20220505182555.370074-1-zlang@kernel.org>
 <20220506161929.GQ27195@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220506161929.GQ27195@magnolia>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Fri, May 06, 2022 at 09:19:29AM -0700, Darrick J. Wong wrote:
> On Fri, May 06, 2022 at 02:25:55AM +0800, Zorro Lang wrote:
> > After soft limits are exceeded, within the grace time, fs quota should
> > allow more space allocation before exceeding hard limits, even if
> > allocating many small files.
> > 
> > This case can cover bc37e4fb5cac (xfs: revert "xfs: actually bump
> > warning counts when we send warnings"). And will help to expose later
> > behavior changes on this side.
> > 
> > Signed-off-by: Zorro Lang <zlang@redhat.com>
> > ---
> >  tests/generic/690     | 125 ++++++++++++++++++++++++++++++++++++++++++
> >  tests/generic/690.out |   2 +
> >  2 files changed, 127 insertions(+)
> >  create mode 100755 tests/generic/690
> >  create mode 100644 tests/generic/690.out
> > 
> > diff --git a/tests/generic/690 b/tests/generic/690
> > new file mode 100755
> > index 00000000..b1d055dc
> > --- /dev/null
> > +++ b/tests/generic/690
> > @@ -0,0 +1,125 @@
> > +#! /bin/bash
> > +# SPDX-License-Identifier: GPL-2.0
> > +# Copyright (c) 2022 Red Hat Inc.  All Rights Reserved.
> > +#
> > +# FS QA Test 690
> > +#
> > +# Make sure filesystem quota works well, after soft limits are exceeded. The
> > +# fs quota should allow more space allocation before exceeding hard limits
> > +# and with in grace time.
> 
> 'within'

Thanks, a typo :-D

> 
> > +#
> > +# But different with other similar testing, this case trys to write many small
> > +# files, to cover bc37e4fb5cac (xfs: revert "xfs: actually bump warning counts
> > +# when we send warnings"). If there's a behavior change in one day, this case
> > +# might help to detect that too.
> > +#
> > +. ./common/preamble
> > +_begin_fstest auto quota
> > +
> > +# Override the default cleanup function.
> > +_cleanup()
> > +{
> > +	restore_project
> > +	cd /
> > +	rm -r -f $tmp.*
> > +}
> > +
> > +# Import common functions.
> > +. ./common/quota
> > +
> > +# real QA test starts here
> > +_supported_fs generic
> > +_require_scratch
> > +_require_quota
> > +_require_user
> > +_require_group
> > +
> > +create_project()
> > +{
> > +	rm -rf $SCRATCH_MNT/t
> > +	mkdir $SCRATCH_MNT/t
> > +	$XFS_IO_PROG -r -c "chproj 100" -c "chattr +P" $SCRATCH_MNT/t
> > +	chmod ugo+rwx $SCRATCH_MNT/t/
> > +
> > +	rm -f $tmp.projects $tmp.projid
> > +	if [ -f /etc/projects ];then
> > +		cat /etc/projects > $tmp.projects
> > +	fi
> > +	if [ -f /etc/projid ];then
> > +		cat /etc/projid > $tmp.projid
> > +	fi
> > +
> > +	cat >/etc/projects <<EOF
> > +100:$SCRATCH_MNT/t
> > +EOF
> > +	cat >/etc/projid <<EOF
> > +$qa_user:100
> > +EOF
> > +	PROJECT_CHANGED=1
> > +}
> > +
> > +restore_project()
> > +{
> > +	if [ "$PROJECT_CHANGED" = "1" ];then
> > +		rm -f /etc/projects /etc/projid
> > +		if [ -f $tmp.projects ];then
> > +			cat $tmp.projects > /etc/projects
> > +		fi
> > +		if [ -f $tmp.projid ];then
> > +			cat $tmp.projid > /etc/projid
> > +		fi
> > +	fi
> > +}
> 
> Please just hoist these out of generic/603.

Do you mean make create_project() and restore_project() to be common functions
in common/quota ?

> 
> > +
> > +# Make sure the kernel supports project quota
> > +_scratch_mkfs >$seqres.full 2>&1
> > +_scratch_enable_pquota
> > +_qmount_option "prjquota"
> > +_qmount
> > +_require_prjquota $SCRATCH_DEV
> > +
> > +exercise()
> > +{
> > +	local type=$1
> > +	local file=$SCRATCH_MNT/testfile
> > +
> > +	echo "= Test type=$type quota =" >>$seqres.full
> > +	_scratch_unmount
> > +	_scratch_mkfs >>$seqres.full 2>&1
> > +	if [ "$1" = "P" ];then
> > +		_scratch_enable_pquota
> > +	fi
> > +	_qmount
> > +	if [ "$1" = "P" ];then
> > +		create_project
> > +		file=$SCRATCH_MNT/t/testfile
> > +	fi
> > +
> > +	setquota -${type} $qa_user 1M 500M 0 0 $SCRATCH_MNT
> > +	setquota -${type} -t 86400 86400 $SCRATCH_MNT
> > +	repquota -v -${type} $SCRATCH_MNT | grep -v "^root" >>$seqres.full 2>&1
> 
> So this sets a soft limit of 1M, a hard limit of 500M, and a grace
> period of one day?  And then we try to write 101M to a file?

Maybe 102M, due to the first file is 2M, to exceed soft limit(1M), then later
100*1M files. Anyway, the 102M isn't necessary, just try to create a scattering
of hundred files. Hope 100 is enough :)

> 
> I think this looks good other than the remarks I had above.
> 
> --D
> 
> > +	# Exceed the soft quota limit a bit at first
> > +	su $qa_user -c "$XFS_IO_PROG -f -t -c 'pwrite 0 2m' -c fsync ${file}.0" >>$seqres.full 2>&1
> > +	# Write more data more times under soft quota limit exhausted condition,
> > +	# but not reach hard limit. To make sure the it won't trigger EDQUOT.
> > +	for ((i=1; i<=100; i++));do
> > +		su "$qa_user" -c "$XFS_IO_PROG -f -c 'pwrite 0 1m' -c fsync ${file}.$i" >>$seqres.full 2>&1
> > +		if [ $? -ne 0 ];then
> > +			log "Unexpected error (type=$type)!"
> > +			break
> > +		fi
> > +	done
> > +	repquota -v -${type} $SCRATCH_MNT | grep -v "^root" >>$seqres.full 2>&1
> > +}
> > +
> > +_qmount_option "usrquota"
> > +exercise u
> > +_qmount_option "grpquota"
> > +exercise g
> > +_qmount_option "prjquota"
> > +exercise P
> > +
> > +echo "Silence is golden"
> > +# success, all done
> > +status=0
> > +exit
> > diff --git a/tests/generic/690.out b/tests/generic/690.out
> > new file mode 100644
> > index 00000000..6f3723e3
> > --- /dev/null
> > +++ b/tests/generic/690.out
> > @@ -0,0 +1,2 @@
> > +QA output created by 690
> > +Silence is golden
> > -- 
> > 2.31.1
> > 
> 

