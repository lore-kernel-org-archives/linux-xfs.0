Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 154414AD4AA
	for <linux-xfs@vger.kernel.org>; Tue, 13 Oct 2026 21:18:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791926338; cv=none; b=uf1rHqSJZPfgJedDkSlWQo0F89h/fcxYb1GtfOCP3nr0rTGBpP6GfpOykxz250+zSl4W3lF0f1cFk69e61WAlsGrRSGtwemxCIaQRh9cL35J5Wv1Jlfrm8aR1XiwrLSZpIi7Npnx6kEAbPBNYsHGn60q0iM/R/+X+5j9luAzNnY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791926338; c=relaxed/simple;
	bh=DcHAJtiRMoQQoPaNuktJ0lPhDIuy1q6Lnltf1sKoGsQ=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=aNmNALf2FDIc5GBKG+fJKZJlSmFxZiIYLm/vzJFn0zUuu/F1/r9arQMEYRbDRRg7d0u1GGbJzLuJe7RamGUzw6Ut0IK4TQqfgARXzmDk0KCFmyWEhV1zkUV5j5OOdSQVoM6vhLX294omOK8DyMOvuXN8ja/Zel8veDcSWwuGYFc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=h6hRT5TW; dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b=sG5HgX4T; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="h6hRT5TW";
	dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b="sG5HgX4T"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1791926335;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding;
	bh=gj3lBzj+20EAhA5hGUYdSFahppylV+rtXiImxVqFde8=;
	b=h6hRT5TWqTbnrJKol0eomk+DxanQp7O1WALxDgSt+IT1o6rFJeL8LKpkhpN4L4vZKd4LOQ
	TXQNwQr6GuLclGOExOpf6GdIqtAd+MMhIaT/hj08HRAp3VGcdbOo0UHYHCOnt96GcyBTYK
	kx4QAroefWahvphmy1pWInbVK5gLzXo=
Received: from mail-qk1-f198.google.com (mail-qk1-f198.google.com
 [209.85.222.198]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-468-HKm5FJYJMLGClxjw6BQP3Q-1; Tue, 13 Oct 2026 21:18:54 +0000
X-MC-Unique: HKm5FJYJMLGClxjw6BQP3Q-1
X-Mimecast-MFC-AGG-ID: HKm5FJYJMLGClxjw6BQP3Q_1791926334
Received: by mail-qk1-f198.google.com with SMTP id af79cd13be357-93cb7f9bb86so689725785a.2
        for <linux-xfs@vger.kernel.org>; Tue, 13 Oct 2026 14:18:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=redhat.com; s=google; t=1791926334; x=1792531134; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=gj3lBzj+20EAhA5hGUYdSFahppylV+rtXiImxVqFde8=;
        b=sG5HgX4T6qqR7cv19Q6PXnODPM3mmXKxpMWWP3U3ii+TVZYUFzQCD5aasF2C2oBSP5
         VRpeietbIkxnu8FPQKp8PODk6qBP5JJV1TOnsS03ofnlhctFpr1g0UmRXhsF5vdhFywE
         twipsztyx6AS5bdV7p1cNQdy10amRqNi0nCqhIiu/WUvJDtJfUnWaWBtPeyo00Vfwf7y
         66nxeLI+B+49ssfDaXqwwnQehelkA/aD/I2Z2JNhiF/5Xdh+n0STIq29X5ejqNyUTfnX
         FDfuv8l6CfxywSF25zyLwuqEq8e+VExImJyEjAFCoV5/atatQDOzbP+s3G4KDZRsahqD
         245g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1791926334; x=1792531134;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=gj3lBzj+20EAhA5hGUYdSFahppylV+rtXiImxVqFde8=;
        b=bIb7A0+YzFSYOlrEix8T/PUxrETNkMvF0RYbozNjvWwy2sJMdruePt4GrBJ/K3ke0B
         Y6YWy9Fm4DuhCwaNRlUUJ8KVLU/xfgitIVcDxeIR3WaCPB3EeAlOKc5mzj2y6RCo/Au3
         Ra6WkMSVL+EPgXUI6Fpu0Whbi8EpBr0Y1ZGi4ec0yabd7dCTVhSDUelmsKTT5O8+ojPT
         JULf0Ae+7/Jit3ckZ7KUp7oLeRjwarouEwT2Tyn0HWPJRmwJMsddFyk5RvQBx4L1N9px
         juPa9buo39O4J/qB5mb7xqHNSW2LOTesE3jqcuH23QUHbg05lS1UhzA10ktmEURZGR/o
         MqDw==
X-Gm-Message-State: AFq9FYJ+W3NkFW45fMt2udmHjP84ybTEOFRQCRhcdMZDQsQP6IXEoUBJ
	etBwLj6w3f+B7vagNFzmpIn9MsPi+2401rQq4mOtU4HEpwmNjO4ihCs0fSkFHde8Ton1t3T8yaj
	kZErsVgrB7Mx2mfCzHl6zg3vblct+UkrnC87xkNI9Re3yWfE8A/N9np1oqio37xz82WCTTwR8Yb
	zuWkMVEQC++gMRkhyyV5q6vwBX8b6SftVVJqbTBKpJKKGx
X-Gm-Gg: AYBFou1ZDPiyEOZ+4onvs+PYYEsNjxKUyyXVq/Gxw8Ka+TTP06FUN2dD+T71eTeEzrM
	pb3GSjhjr/VyqR3cV20hZd0l0evs5yidZbhjWu53SECaQ8VZccx9BoF2LXtAQiLmDo2+45Isk9N
	iuYwmZOng3LC6A4zQqRPAh6KFSMXm72uYRmGLD9DHqOe1eQiAHTMwSC+mNjwxYSTdrX8GS+CWWe
	UM2cNwSoUMcn8IwpE3QLlBG+SSbGq5DKKsrpgp51997izgAcygn/q8OoY8Trl073zzVatUuIRIY
	+rDiLThhcgKmqelmmviFlN+4BgPRkDvF7yqEFucSsYVDs2sVPop8xYy96lnJ7zQ+ScoKsVIW/rP
	smZmSIAvLkS37he3GbInzm72AYT0Nl27cb2/asg==
X-Received: by 2002:a05:620a:2691:b0:93e:a51e:7ffb with SMTP id af79cd13be357-93ebd0bfcd2mr2276745485a.2.1791926333932;
        Tue, 13 Oct 2026 14:18:53 -0700 (PDT)
X-Received: by 2002:a05:620a:2691:b0:93e:a51e:7ffb with SMTP id af79cd13be357-93ebd0bfcd2mr2276740985a.2.1791926333357;
        Tue, 13 Oct 2026 14:18:53 -0700 (PDT)
Received: from big24.sandeen.net (97-116-156-223.mpls.qwest.net. [97.116.156.223])
        by smtp.gmail.com with ESMTPSA id af79cd13be357-93ef5051333sm330030785a.28.2026.10.13.14.18.52
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 13 Oct 2026 14:18:52 -0700 (PDT)
From: Eric Sandeen <sandeen@redhat.com>
To: linux-xfs@vger.kernel.org
Cc: cem@kernel.org,
	djwong@kernel.org,
	hch@lst.de
Subject: [PATCH 0/2] xfs: add missing cursor status check after btree ops
Date: Tue, 13 Oct 2026 16:07:45 -0500
Message-ID: <20261013211851.641256-1-sandeen@redhat.com>
X-Mailer: git-send-email 2.55.0
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

I've been looking at ways to reduce/eliminate the frequency of the:

	if (XFS_IS_CORRUPT(mp, i != 1)) {
		xfs_btree_mark_sick(cnt_cur);
		return -EFSCORRUPTED;
	}

idiom scattered all over the tree, and in doing so I realized we
have a few spots that probably /should/ have this checked but
don't. Sending these first to ease backporting if needed, though
what they should actually get for Fixes: isn't very clear to me as
this error handling has evolved over time I think.

I did run these through xfstests but I can't guarantee the change
was tested in any targeted way, so it's mostly inspection.

After these I'll send a series that floats the idea of removing this
idiom completely from btree insert/delete type fns because "stat" is
never different from "error" in practice, but that's a story for
another day and I need to do a bit more testing first.

Thanks,
-Eric

