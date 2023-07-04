Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4A4FAEB64D9
	for <linux-xfs@archiver.kernel.org>; Tue,  4 Jul 2023 14:23:42 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231781AbjGDOXl (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 4 Jul 2023 10:23:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47886 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231642AbjGDOXk (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 4 Jul 2023 10:23:40 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9CBFBE49
        for <linux-xfs@vger.kernel.org>; Tue,  4 Jul 2023 07:22:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1688480574;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=Y1FCPb3UjjIlq2IWt6mOqtBbhOF0NVRHcyVgC1SCltI=;
        b=bv9iowpZsWjWysgyzZDRuUcpEKcaq242t4aKPVYHE3Nhe17326dz+Zp9No0RgViV50bEjX
        EARAf9LKNBUTaDYZKliNNnxoPcoSD4yzdvbhuznLFVpWiHlHdAMiiE63MiQwPPvwG/ZceS
        beOW9hHs4qtKkaWk6NcVIkDFyDhVygE=
Received: from mail-qv1-f72.google.com (mail-qv1-f72.google.com
 [209.85.219.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-434-IX2WSb10PPKVfe2vFXyUXQ-1; Tue, 04 Jul 2023 10:22:53 -0400
X-MC-Unique: IX2WSb10PPKVfe2vFXyUXQ-1
Received: by mail-qv1-f72.google.com with SMTP id 6a1803df08f44-635e6c83cf0so57451576d6.3
        for <linux-xfs@vger.kernel.org>; Tue, 04 Jul 2023 07:22:53 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1688480573; x=1691072573;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Y1FCPb3UjjIlq2IWt6mOqtBbhOF0NVRHcyVgC1SCltI=;
        b=bwUbDLmsTGQwYrIzU0CWvzN9XaoRn8dusRyEezGTkZVBOv1Og6uohZSC2yE+k/XnAz
         QHah/oILe6egkk8uWtsiuFNWmxoPAVejdBj3ieiTU1Sfrde8b0BtaObIdOPrKMY76yYz
         QmQhkxQ+vLMFRoYsu755tXz2P8lJosF5ZdpVnHMp6+HyRKouvpE4zlRZB3ZjfIlbEzo6
         hn9cFEVOJ2+igp4xLbrAPpnh5WvOfQxgp6HyMw2Q539Kt2BWtiI5nUxNf9u7ZCShYOL7
         6GB+BIgm3IzvdJ4ofMvETeGctGWoBnX6pvHGhJrssxwcfY9rECDsk9CnmwVzwPlnI5UV
         xcTw==
X-Gm-Message-State: ABy/qLYKLusdixlXB5Bz28iTBRhXVzO2mUGem65/j9BPHPOmyLAFGuNq
        sAHb4pSywhvRB4nqSMw3eN4hpcORJvnEXsBxm+OXED85bILCmiNT3oC1ZxC+PjMZAy0NnvdFjxP
        5RBxIoeV3+aUVAmS7yOWP7BUMcjo=
X-Received: by 2002:a0c:e9c7:0:b0:636:326c:2288 with SMTP id q7-20020a0ce9c7000000b00636326c2288mr12383836qvo.63.1688480573151;
        Tue, 04 Jul 2023 07:22:53 -0700 (PDT)
X-Google-Smtp-Source: APBJJlEYJpjPl+vnISLGOYuZbKtA3iFPoWqRqx3Mh8H/4OubiFCW6y6Vu6lsb/Al71+lykFlcUBRDQ==
X-Received: by 2002:a0c:e9c7:0:b0:636:326c:2288 with SMTP id q7-20020a0ce9c7000000b00636326c2288mr12383823qvo.63.1688480572932;
        Tue, 04 Jul 2023 07:22:52 -0700 (PDT)
Received: from aalbersh.remote.csb ([109.183.6.197])
        by smtp.gmail.com with ESMTPSA id dk13-20020a056214092d00b005dd8b9345besm12611293qvb.86.2023.07.04.07.22.51
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 04 Jul 2023 07:22:52 -0700 (PDT)
Date:   Tue, 4 Jul 2023 16:22:49 +0200
From:   Andrey Albershteyn <aalbersh@redhat.com>
To:     "Darrick J. Wong" <djwong@kernel.org>
Cc:     zlang@redhat.com, linux-xfs@vger.kernel.org,
        fstests@vger.kernel.org, guan@eryu.me
Subject: Re: [PATCH 4/5] xfs/041: force create files on the data device
Message-ID: <20230704142249.bys4vlk5iryewd3z@aalbersh.remote.csb>
References: <168840381298.1317961.1436890061506567407.stgit@frogsfrogsfrogs>
 <168840383563.1317961.17059869339313726876.stgit@frogsfrogsfrogs>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <168840383563.1317961.17059869339313726876.stgit@frogsfrogsfrogs>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On 2023-07-03 10:03:55, Darrick J. Wong wrote:
> From: Darrick J. Wong <djwong@kernel.org>
> 
> Since we're testing growfs of the data device, we should create the
> files there, even if the mkfs configuration enables rtinherit on the
> root dir.
> 
> Signed-off-by: Darrick J. Wong <djwong@kernel.org>
> ---
>  tests/xfs/041 |    3 +++
>  1 file changed, 3 insertions(+)
> 
> 
> diff --git a/tests/xfs/041 b/tests/xfs/041
> index 05de5578ff..21b3afe7ce 100755
> --- a/tests/xfs/041
> +++ b/tests/xfs/041
> @@ -46,6 +46,9 @@ bsize=`_scratch_mkfs_xfs -dsize=${agsize}m,agcount=1 2>&1 | _filter_mkfs 2>&1 \
>  onemeginblocks=`expr 1048576 / $bsize`
>  _scratch_mount
>  
> +# We're growing the data device, so force new file creation there
> +_xfs_force_bdev data $SCRATCH_MNT
> +
>  echo "done"
>  
>  # full allocation group -> partial; partial -> expand partial + new partial;
> 

Looks good to me:
Reviewed-by: Andrey Albershteyn <aalbersh@redhat.com>

-- 
- Andrey

