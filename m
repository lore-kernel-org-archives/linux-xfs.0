Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1E74039659A
	for <linux-xfs@vger.kernel.org>; Mon, 23 Mar 2026 11:25:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=170.10.129.124
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774265148; cv=pass; b=KK7HinGb1r0IbxwK0wyRCUQP9v50APFnCvDpVvSL+eliKqWDnXaOab9OBJGvcv2E5Km3GzveIz46XkbYiJrUmvL2TNdrHxGa41WMd/5fjceUqUZ5WlofAh+hvaQxxBHaLZtuarPfwkU53xNVFJhFNSLrHrpp6ozn9ttXzJ/DFv8=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774265148; c=relaxed/simple;
	bh=SgQG5ejgW1WxUybyAAM8rt7HZkPdDCIfGfpizpvccms=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=UpUl2tGL7bAb+A3gafYlHf9MIDrbAB3WZ/eMT9Wn+MtMM2N+891r3uMLF9GV8vxZiiE7af+j9rFZxLJ6yWZMNpLuaTUGKoVB94oZ+gvMKEdA79h7iVkELl3+tTMUeb6Wh7/RRjm6/HV/cMeoHDBolbYHCcHOap53BfKz922scKw=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=GXwyL2In; dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b=BFM5IOm0; arc=pass smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="GXwyL2In";
	dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b="BFM5IOm0"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1774265146;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=67u/NLiGVOP5D7N4bIRzvnVB/KnTMtvWXarwYg+7w48=;
	b=GXwyL2InMZnJz//2fb+yGFyUyAZ0cW7xOpEzo4KtI7MwiAMTSKPIk/MSDdoaRw6zM5XahF
	ikw+fNd11dv6LmePrkTlNSPriv5ITBffOS0fA5kqbEpcXntx2LXsozKdEJIObkjYErRoy0
	L4GIKnHNk/kcKC+OmTejDE7smU/NqrI=
Received: from mail-ej1-f72.google.com (mail-ej1-f72.google.com
 [209.85.218.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-505-O2wfzzaAP2uJDikutEYrDg-1; Mon, 23 Mar 2026 07:25:45 -0400
X-MC-Unique: O2wfzzaAP2uJDikutEYrDg-1
X-Mimecast-MFC-AGG-ID: O2wfzzaAP2uJDikutEYrDg_1774265144
Received: by mail-ej1-f72.google.com with SMTP id a640c23a62f3a-b97d773ea61so3155766b.2
        for <linux-xfs@vger.kernel.org>; Mon, 23 Mar 2026 04:25:44 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1774265144; cv=none;
        d=google.com; s=arc-20240605;
        b=k6aBYoobBWp+NaG8Frzq2KKq0X61dC4zWuI22aMlJwc/jQNijinMHzjG9v9UP8YMob
         a8aXBZvrlAfvMUL2ntLoGxIrABulqcmoKq9vEfLbPjVaBvwS6bqJiKLzKTm+61DGJNqm
         SDtHsR6po/KIliph8I34+o+0is3zefI6WIpQ0mv6qA2bKazb7yK8W/4w9lgxGUelm5ej
         niY0wXsVtmf0N7yiL/KPmeCUskvMvsnq2jnrn8ZFWGvKYYHU+VkVXWm7wVgFhWx9//Z/
         kayZLKAY6Lrprwhyf0x2J8iX1/gpM1w5kwP5kAOVtQlUfSbIZJt4cX8FjmDHanP51tER
         yVyQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:dkim-signature;
        bh=67u/NLiGVOP5D7N4bIRzvnVB/KnTMtvWXarwYg+7w48=;
        fh=0jc0A/C9yKIDAIE2hfHqKyTALazPduOP9LASXsP7bTA=;
        b=D/MLIndeJeVN4AyP0FO01oQR5wwh6RACKsEP4RQ1dYXR88wkfm0bypLBHJ3HIxdSq5
         80cjFayp/r2eYnF44yivq+yjfYvixGvq4CeBGWyQgykRt0frlJsljOKbkouP08cIJven
         USLl62nGdqFvQjzh6SFHV73wfvkspsE/g/1zKZ6A+5oZAsC0NnOCiuz22yF666k0Zcpu
         14O+aCPwjx8TSNHBnh32NxMyFobuWeroQh52ub4o4Zo0d4sGEGV5KwlcWt2bx4mM5N69
         9DeW5YGlx2wW/d0LWssUoEovKf0EuhcTupBFiIgBzsd+4CRYsM1vyCTdPuxwm5dglgzs
         gUMQ==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=redhat.com; s=google; t=1774265144; x=1774869944; darn=vger.kernel.org;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=67u/NLiGVOP5D7N4bIRzvnVB/KnTMtvWXarwYg+7w48=;
        b=BFM5IOm0ujBTheVt0YbvH6RkTFNULjyrE2ZSp/yGlwPLlfp1IIa5QE8gZ4WgjgTZ99
         bcBPAB4jhH0AbcyqqqC3snHlf4EA258EAX66pjOgQVRBYZ8DMy8vZrSsnctJyuvC7bD9
         b8xZURQsQC8ZSXi8G+jC75NI8egi2B49cwzXyfmEq1+VSzm6NLBdvzPAXEy+meqoTjgM
         c08oAnT2dsgFjlBnG/jzMkwk92wcbanNNupA4DeGa6cQh8EfWvI0DnnV3OVTvXbTMjma
         FBrHRECBVI2Abh9g1uqUNOPFyx+0+QqiUSVo5rxbEsgPYTuwj/yNfHl3gG0rzBqIT68j
         LoZw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1774265144; x=1774869944;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=67u/NLiGVOP5D7N4bIRzvnVB/KnTMtvWXarwYg+7w48=;
        b=bYcpLj/iKzFXYlMvuUo/Ms7AecccbLKCGClNMfKNmgjYsm5JJMxPc8jbAVORE4Wfkh
         V7VM5m5/ZCyvoreJlwePzx3MpitULMlqbKy2eR5jenjpngGlgYx4MEJRgwnXbHwSkZb5
         9xnd+i9aFAL2bQvJxQbIc9ph6EkPiMTi8kNPq2nJFYWR5W2An1epbYNwYVT2VuTLtZB9
         C4np6UIEMlI0d0k8QAH+cOAxQSaxGMnfugEeXhUEEprGUjA0TXs7S1y4qwM+cJd1sY/t
         qKs0d8KLaPQ/6Z/HZ6aAxmjNMPBDObJHyPArTjgyfdy7kZIp+0zYD3pESqhleRtNDRr9
         EkwQ==
X-Forwarded-Encrypted: i=1; AJvYcCXSGiaKqIBH4XLQyRnNUaIakA/AV4nEdrYEQfp/mDL3NpFu0wnfZjfPwa5HxW/U15dExZJLSPwVvwg=@vger.kernel.org
X-Gm-Message-State: AOJu0Yx0pHTw5rMjmELPtJswCIK/LAuWfAghYMYmemDwOKsC/J89/Rv2
	WFZGG/PLcTs4/rYHhNt4kf/BqO55CFC5qUQAtioK6YxhQmC2J1cdx6WXkHqtEAqEc1UhhXWo91X
	Qid2bUKLoScK8EMDeWZTnGM9Q0IGO2uJ6z72mKlqznEhQj2ikn/KA1ZxKi/VGzYnasoLuQ3n254
	JAKBTyxBbTpfdnM8U/G/3M68zH/tdAzGMUakOE
X-Gm-Gg: ATEYQzxZTOrYjoaOeAKMWM9BncT0m70Agysx97ryuq/tn783WwhYMIpEKMHTGFJ74P2
	CCfidDPSPNAHQ2r4V4Mrvgt+nrfrVfW2aQC16fIjDOH5YPanBUEEAixfNkxZFeuBKAeVkFuAwBe
	tH0UUziqdjLJ/eysvPXdIcYwWcpzE9fb7Jd9/79zrfa+Tp60LtZztHWW5F3XOBwjLXgrBtwhTpb
	17hPsfQ
X-Received: by 2002:a17:907:2d14:b0:b98:6c41:a77f with SMTP id a640c23a62f3a-b986c41b6bbmr251633966b.20.1774265143440;
        Mon, 23 Mar 2026 04:25:43 -0700 (PDT)
X-Received: by 2002:a17:907:2d14:b0:b98:6c41:a77f with SMTP id
 a640c23a62f3a-b986c41b6bbmr251630966b.20.1774265142881; Mon, 23 Mar 2026
 04:25:42 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260312090810.1145908-1-ravising@redhat.com> <20260317065947.306954-1-ravising@redhat.com>
 <jknk6pwirqp5kgxdwr7qez2qzuycmj4eupknf3yvqzlnkyiu5k@nowg6cwpxqc3>
 <20260317133159.GA53921@macsyma-wired.lan> <ijwjh525hgf54wclhd4oixvfi3gfrodqrh2pbk7lr3whqw7nqo@k5uotrmekwyt>
 <20260318221810.GM1742010@frogsfrogsfrogs> <waksu55vh2fm74ltktchuckhezkjq4ggaooqrosixfzsuli5uo@i4q6ixu7r56x>
In-Reply-To: <waksu55vh2fm74ltktchuckhezkjq4ggaooqrosixfzsuli5uo@i4q6ixu7r56x>
From: Ravi Singh <ravising@redhat.com>
Date: Mon, 23 Mar 2026 16:55:31 +0530
X-Gm-Features: AQROBzDv_PXbd61Y_t8LXNzL7Rn5JZDsfsrrP-vHw5-ek6F4YVqT9iiVk_OZ2CM
Message-ID: <CAF-d4OvGmXWRinOB_qQYbCX9pckGLQbu1pghqDm-LhzHOaQY6Q@mail.gmail.com>
Subject: Re: [PATCH v2] xfs: return default quota limits for IDs without a dquot
To: Jan Kara <jack@suse.cz>
Cc: "Darrick J. Wong" <djwong@kernel.org>, Theodore Tso <tytso@mit.edu>, linux-xfs@vger.kernel.org, 
	linux-fsdevel@vger.kernel.org, adilger@dilger.ca, jack@suse.com, 
	cem@kernel.org
Content-Type: text/plain; charset="UTF-8"

Hi all,

Thanks for the feedback. Before posting a v3, I wanted to share some
additional findings. The v2 patch only covers one of three scenarios
where an unprivileged user cannot see the default limits applying to them.

Scenario 1: No dquot on disk (v2 fixes this):
xfs_qm_dqget() returns -ENOENT, and v2 catches it.

mkfs.xfs /dev/vde -f
mount -o quota /dev/vde /mnt/test
xfs_quota -xc 'limit -u bsoft=10m bhard=20m 0' /mnt/test
# Do NOT chown anything to testuser8 - no dquot exists
su - testuser8 -c "xfs_quota -c 'quota -ub' /mnt/test/"

Without fix: empty output
With fix:
Disk quotas for User testuser8 (1003)
Filesystem              Blocks      Quota      Limit  Warn/Time      Mounted on
 /dev/vde                     0      10240      20480   00 [--------] /mnt/test

Scenario 2: dquot exists with non-zero counts but zero limits (v2 does NOT fix):

A dquot is created for testuser8 before default limits are configured.
When the chown runs, xfs_qm_adjust_dqlimits() is called in
xfs_trans_apply_dquot_deltas(), but the defaults are all zero at that
point so nothing is pushed into the dquot. When the admin later sets
limits on ID 0, testuser8's existing dquot is not retroactively updated.
xfs_qm_dqget() succeeds and XFS_IS_DQUOT_UNINITIALIZED is
false (q_ino.count != 0), so xfs_qm_scall_getquota_fill_qc() returns
the dquot's zero limits.

mkfs.xfs /dev/vde -f
mount -o quota /dev/vde /mnt/test
mkdir /mnt/test/testuser8
chown testuser8:testuser8 /mnt/test/testuser8
xfs_quota -xc 'limit -u bsoft=10m bhard=20m 0' /mnt/test
su - testuser8 -c "xfs_quota -c 'quota -ub' /mnt/test/"
# empty output

Scenario 3 : dquot all zeros / XFS_IS_DQUOT_UNINITIALIZED (v2 does NOT fix):

A dquot record persists on disk with all zero fields after ownership
is transferred away. xfs_qm_dqget() succeeds, but XFS_IS_DQUOT_UNINITIALIZED
returns true and the query returns -ENOENT. The v2 fallback does not
trigger because it only handles the xfs_qm_dqget() error path.

mkfs.xfs /dev/vde -f
mount -o quota /dev/vde /mnt/test
mkdir /mnt/test/testuser8
chown testuser8:testuser8 /mnt/test/testuser8
chown root:root /mnt/test/testuser8
xfs_quota -xc 'limit -u bsoft=10m bhard=20m 0' /mnt/test
su - testuser8 -c "xfs_quota -c 'quota -ub' /mnt/test/"
# empty output

I see two approaches for v3 and would appreciate guidance:

1. Fix all three in xfs_qm_scall_getquota() by merging default limits
    into the response for any zero-valued limit field, mirroring
    xfs_qm_adjust_dqlimits().
2.  Expose default limits through Q_XGETQSTATV using the available
     padding space in fs_quota_statv, as Jan suggested, and let
     userspace tools merge them.

Thoughts?

Thanks,
Ravi

