Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EEA02C38147
	for <linux-xfs@archiver.kernel.org>; Wed, 18 Jan 2023 15:59:26 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230263AbjARP7W (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 18 Jan 2023 10:59:22 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33216 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229637AbjARP6k (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 18 Jan 2023 10:58:40 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 910EB4ED2D
        for <linux-xfs@vger.kernel.org>; Wed, 18 Jan 2023 07:54:11 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1674057250;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=yNmPUOg+Q6DfG4G+z/22PLD8WIx1Pvt4BSL8iZgqzP0=;
        b=LALWDYHf+icz5u/8h+xQvlgnw09A5Mr9du4XrhtbQ+B5+BKnaLScICmyeTMX7Dtkvc92+8
        oyozq9MII2y7u8zk9cd13bMqqQLjmaNiJzqJ/LDhjLYQKJnhY7ijH0ttB9QDmttUSYc/bK
        EztKq8COgYqagYO6JlgGpxE4EwztSHY=
Received: from mail-pg1-f197.google.com (mail-pg1-f197.google.com
 [209.85.215.197]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-494-FzpJ006WMB-3O8Kn7SL1aw-1; Wed, 18 Jan 2023 10:54:09 -0500
X-MC-Unique: FzpJ006WMB-3O8Kn7SL1aw-1
Received: by mail-pg1-f197.google.com with SMTP id h69-20020a638348000000b004d08330e922so1109945pge.5
        for <linux-xfs@vger.kernel.org>; Wed, 18 Jan 2023 07:54:08 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=yNmPUOg+Q6DfG4G+z/22PLD8WIx1Pvt4BSL8iZgqzP0=;
        b=PJsWB3UJE4aGI0wa9/MubQEnu7T114ebwU1DbE3+5fgM+wtwSTR/Yjuzwg3r39jO3O
         B86J0wSJlLV82EiB8+lPVy6ip3qmtLVWFqn1o82eBPMojTXEgR/BF0AOQ47Svw4Go5Gz
         oo8Ee5mUyHlE2bf3zRa3GAsmRrl0uQD2W6hkbI0/BqGnYJzRGOEQms7kKMLi70QrAurx
         nmlaxv/bUFM+FhdX+XeyZPmK7q4tJ9OzVHuXL7/5w24TwS5yNuGSXasLBGHRtoU/h1AO
         yw/oTtqSg2JHgMJv5CDjaMp9//vjgAoc1ihwENVba3Xs/aKN3Z1g6xKx2wK8Ctx9FG1z
         zPcA==
X-Gm-Message-State: AFqh2kqsolzsOudcfnWyo+x9vo19+2SFRrK5lZZ4Nsj5VGY8ugOLv0BY
        sOWLghTcyJ6uFMZKqJak52m3WkMACoH2C2zaLiedgIgiUfqO9PGGHqTK6pwy54B9WO5rFHHGZGR
        roCkOy2MSnih/tw15q2xe
X-Received: by 2002:a05:6a20:d818:b0:ad:def6:af3 with SMTP id iv24-20020a056a20d81800b000addef60af3mr8353701pzb.57.1674057247858;
        Wed, 18 Jan 2023 07:54:07 -0800 (PST)
X-Google-Smtp-Source: AMrXdXsHN3DO4XOuDZ4e4WUkJUeR1oUNAEboRzGPPxFCPN7285NjlnkY97mQKOKFVuVQ8hTzGHk81A==
X-Received: by 2002:a05:6a20:d818:b0:ad:def6:af3 with SMTP id iv24-20020a056a20d81800b000addef60af3mr8353685pzb.57.1674057247599;
        Wed, 18 Jan 2023 07:54:07 -0800 (PST)
Received: from zlang-mailbox ([209.132.188.80])
        by smtp.gmail.com with ESMTPSA id r6-20020a63d906000000b004b3de07bfaasm7060047pgg.10.2023.01.18.07.54.05
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 18 Jan 2023 07:54:07 -0800 (PST)
Date:   Wed, 18 Jan 2023 23:54:03 +0800
From:   Zorro Lang <zlang@redhat.com>
To:     "Darrick J. Wong" <djwong@kernel.org>
Cc:     linux-xfs@vger.kernel.org, fstests@vger.kernel.org
Subject: Re: [PATCH 4/4] populate: improve runtime of __populate_fill_fs
Message-ID: <20230118155403.pg7aq3gtcks2ptdz@zlang-mailbox>
References: <167400103044.1915094.5935980986164675922.stgit@magnolia>
 <167400103096.1915094.8399897640768588035.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <167400103096.1915094.8399897640768588035.stgit@magnolia>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Tue, Jan 17, 2023 at 04:44:33PM -0800, Darrick J. Wong wrote:
> From: Darrick J. Wong <djwong@kernel.org>
> 
> Run the copy loop in parallel to reduce runtime.  If filling the
> populated fs is selected (which it isn't by default in xfs/349), this
> reduces the runtime from ~18s to ~15s, since it's only making enough
> copies to reduce the free space by 5%.
> 
> Signed-off-by: Darrick J. Wong <djwong@kernel.org>
> ---
>  common/populate |    3 ++-
>  1 file changed, 2 insertions(+), 1 deletion(-)
> 
> 
> diff --git a/common/populate b/common/populate
> index f34551d272..1c3c28463f 100644
> --- a/common/populate
> +++ b/common/populate
> @@ -151,8 +151,9 @@ __populate_fill_fs() {
>  	echo "FILL FS"
>  	echo "src_sz $SRC_SZ fs_sz $FS_SZ nr $NR"
>  	seq 2 "${NR}" | while read nr; do
> -		cp -pRdu "${dir}/test/1" "${dir}/test/${nr}"
> +		cp -pRdu "${dir}/test/1" "${dir}/test/${nr}" &
>  	done
> +	wait

I'm thinking about what'll happen if we do "Ctrl+c" on a running test which
is waiting for these cp operations.

>  }
>  
>  # For XFS, force on all the quota options if quota is enabled
> 

