Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0F228C7EE29
	for <linux-xfs@archiver.kernel.org>; Wed,  7 Jun 2023 02:25:12 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234406AbjFGCZJ (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 6 Jun 2023 22:25:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48424 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240525AbjFGCZJ (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 6 Jun 2023 22:25:09 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1DC941726
        for <linux-xfs@vger.kernel.org>; Tue,  6 Jun 2023 19:24:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1686104659;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=sPYuMGtWi1u1E44XPgF4NL9OIbC/PKFKS5U0z/na1CU=;
        b=aaGudjpTCx6K/jfkeFg5htUZx7sHg32J+GcH+M2Z6GlGzi3V9coVx+UZfUYwvgc005xPBO
        tF/wwiL+yM1+q1G4GqxC7okbwAI8WBPeLyZ2YBb9K9ScVioZnZfej8DwNJicQT5eX6rTNC
        uhjubgSUXF2I8q3a9YcwW191YI8HDS8=
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-426-3HcVGX1WPLKPelGcGxWZYQ-1; Tue, 06 Jun 2023 22:24:18 -0400
X-MC-Unique: 3HcVGX1WPLKPelGcGxWZYQ-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.rdu2.redhat.com [10.11.54.1])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id B69E13C0C898;
        Wed,  7 Jun 2023 02:24:17 +0000 (UTC)
Received: from redhat.com (unknown [10.22.34.195])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 6E50840CFD46;
        Wed,  7 Jun 2023 02:24:17 +0000 (UTC)
Date:   Tue, 6 Jun 2023 21:24:15 -0500
From:   Bill O'Donnell <billodo@redhat.com>
To:     "Darrick J. Wong" <djwong@kernel.org>
Cc:     zlang@redhat.com, linux-xfs@vger.kernel.org,
        fstests@vger.kernel.org, guan@eryu.me
Subject: Re: [PATCH 3/3] xfs/155: improve logging in this test
Message-ID: <ZH/qT1TPh0ghvji9@redhat.com>
References: <168609054262.2590724.13871035450315143622.stgit@frogsfrogsfrogs>
 <168609055958.2590724.15653702877825285667.stgit@frogsfrogsfrogs>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <168609055958.2590724.15653702877825285667.stgit@frogsfrogsfrogs>
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.1
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Tue, Jun 06, 2023 at 03:29:19PM -0700, Darrick J. Wong wrote:
> From: Darrick J. Wong <djwong@kernel.org>
> 
> If this test fails after a certain number of writes, we should state
> the exact number of writes so that we can coordinate with 155.full.
> Instead, we state the pre-randomization number, which isn't all that
> helpful.
> 
> Signed-off-by: Darrick J. Wong <djwong@kernel.org>

Makes sense.
Reviewed-by: Bill O'Donnell <bodonnel@redhat.com>


> ---
>  tests/xfs/155 |    3 ++-
>  1 file changed, 2 insertions(+), 1 deletion(-)
> 
> 
> diff --git a/tests/xfs/155 b/tests/xfs/155
> index 25cc84069c..302607b510 100755
> --- a/tests/xfs/155
> +++ b/tests/xfs/155
> @@ -63,11 +63,12 @@ done
>  
>  # If NEEDSREPAIR is still set on the filesystem, ensure that a full run
>  # cleans everything up.
> +echo "Checking filesystem one last time after $allowed_writes writes." >> $seqres.full
>  if _check_scratch_xfs_features NEEDSREPAIR &> /dev/null; then
>  	echo "Clearing NEEDSREPAIR" >> $seqres.full
>  	_scratch_xfs_repair 2>> $seqres.full
>  	_check_scratch_xfs_features NEEDSREPAIR > /dev/null && \
> -		echo "Repair failed to clear NEEDSREPAIR on the $nr_writes writes test"
> +		echo "Repair failed to clear NEEDSREPAIR on the $allowed_writes writes test"
>  fi
>  
>  # success, all done
> 

