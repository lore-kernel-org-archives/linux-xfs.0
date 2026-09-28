Received: from mail-wm2-f12.google.com (mail-wm2-f12.google.com [74.125.225.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6E2CF2D8DD0
	for <linux-xfs@vger.kernel.org>; Mon, 28 Sep 2026 16:24:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=74.125.225.140
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790612689; cv=none; b=cqDrVqJ9QwSKbeOcdsJQSvk7s+j1KQnPXwe/s0X3Xzzg/py14iZwMonSJkDSmjStmjWquEFQKp7oLjoRBq0X1cIH/zzrw/1r8+k0HTrsSZsJ7YArnxOeabCk36sBbNVeFIfTxoiOydXC/zrCjN+gH9y/HB32a689wnyp6rNUpXY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790612689; c=relaxed/simple;
	bh=VC1AlWwK6+xkcHdk+oDX/+XlZBn2WYwLvo+m0RuQYiY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Tv0DCmoQDA7dLw07UJj9uEfANgDxt2WrI8qvyqaMnXtBNn8hxbdrZ9eONbkz7mp2X9Pe3nc3HkfY/U9teSY58cCos35EtFDNl+lnuoYlIY8idFl9u1L0MCWJAFJSSf5yUZrFB3mALH2VjcoUMsnH6vxRu3GoiaCZan7sY95EhHg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=rEqoMN0n; arc=none smtp.client-ip=74.125.225.140
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="rEqoMN0n"
Received: by mail-wm2-f12.google.com with SMTP id 5b1f17b1804b1-49b912d391aso24100985e9.2
        for <linux-xfs@vger.kernel.org>; Mon, 28 Sep 2026 09:24:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1790612687; x=1791217487; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=ZpsKAZQhsZqa/8JtSmQCc3cc5x+c13Dua7F09qfzihw=;
        b=rEqoMN0nPcIWwIhcCxs5PMQdff5qX4Lp1k/DhHRVAGyIRfBeCCHfq8BV/7P+8nFWg6
         xA7FC3uQ1zeD8Y3ABhHQR62Kd5cSwW1kDLR5GFjZN39RB1gvYh718Fn17TDSPA1DXhUX
         odwjK2RdBgBQuZHyj13ElSy8034zBbb8yRehWtLQPxN/LiSq86kUTJ0EJ3hHNX9HrsH5
         kFETzxyd2M6k0G0hjmkVZE54slEz9O/W37YRVPAlfdKWgcoxjG/R4bmuGwfdhX/VAO9V
         ws6NDfGUWILg24kf4p1GJWwFU89WgRzO+h8ImVym4HVK4uKFSdjlrIseu1M+5wZM8kIb
         wmew==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1790612687; x=1791217487;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=ZpsKAZQhsZqa/8JtSmQCc3cc5x+c13Dua7F09qfzihw=;
        b=tDIFL5ea3Zm15kyGK+myzlZQAaQFawPC9isTTJF7i/R0+1djmYKb5YCrj3sRSem6PN
         RCFDoaQ36AxDmJ2eg5tKMGJ2bhEtaWEFJGkopQnuKC4W24VKMpQrFoTC6IM86IJsT9OQ
         DLRiYe+W6A01/fYfAYbycfD5ArRjJmDJFN/ToBcdFIM7t9H+U9FgoN1BB2t9T5wj+hSw
         1zpk4RwEWAg9Cva1FIBdSKNG6iBmrxVzI8jRh07xVXgV2rMbAfHEJRBKBUOUhO49zraJ
         6PSWUPBXlTFWf0ULID1uR4KIS1kaOneSivLk2OHQERo6T9/Wy5iS5nsaCiqlQq941J8J
         FCRw==
X-Forwarded-Encrypted: i=1; AKwUvBzKdq5NytZRuyKye/SMXncjxf31eej6WpPzxfmd2BaLUCLA/tBPCOVQsEz/9ha6y3/SyEQDDoQKkzM=@vger.kernel.org
X-Gm-Message-State: AFuF++lbFwWtLiv9j4EtPe+5W73Y47IgnGnqq0fXNWMCaaVZDm1b0Rqj
	74bVor4vwcdndmstl2QvfEZzxV8vsyYrbGqS3N3CdRKylVQXe3ng9q3+2aEypVkB
X-Gm-Gg: AYBFou0Vsreg81EiuAlR4LywpnWLrYhmnTKQvhHTQLqHhfD9WGvZWWOreqsL+kHnprM
	N8MDT119gEjEidnPxfqV6/zKKMmy4hW354Shuna+y7yQoxF0Ra+iS8X5RinhbuyPUKdH/C3Dv9Y
	/xEBMlG1Yl75m7mojvYF37kiHMQhdL9R96+PT1OZrtyAPaY3w82RSXPEHzgF1plFtR7KC0Eh0e8
	+WTPU2dNDhuEmrmvuvBXWfFOsD4vJdiWejU+ItplbGxfdjr84icM4oYV8sRrnDWI81unBMLjKTo
	lcOxM6Uhi6Y5HFul+EreqqmriRSI7XRLKU0iKW7IvF7cLP23C3q5hfuHN0Nx8rPgTTT0yg0fwkX
	sh34YxekYsyaFLjhac4eNh290jxDeeCOOLxNgmq+FgZ4D1leIIF0rBCOJJ2+bWMd8ypYCc6XmMT
	n5eLF3mRi72v7qH2EtVnSqG07Or48gN8PqGdva2z2hK5aFhjMMJiamwHQ3mNoGpfazSWVwM5s5u
	C2N9MhZo271kOXEMlW2gY0dCED+l3aq+TKOrlBbVZAPBl0ZOwrY8D6JC/901+8vFf4PAW0t+rnw
	PbN+
X-Received: by 2002:a05:600c:a06:b0:49f:fd4c:cccd with SMTP id 5b1f17b1804b1-49ffd4ccdd5mr112458605e9.28.1790612686557;
        Mon, 28 Sep 2026 09:24:46 -0700 (PDT)
Received: from andreayoga.localdomain (93-42-14-189.ip84.fastwebnet.it. [93.42.14.189])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4a00cf2d973sm5148155e9.0.2026.09.28.09.24.45
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 28 Sep 2026 09:24:46 -0700 (PDT)
From: Andrea Parri <parri.andrea@gmail.com>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: Zorro Lang <zlang@kernel.org>,
	fstests@vger.kernel.org,
	Christoph Hellwig <hch@infradead.org>,
	linux-xfs@vger.kernel.org,
	Christoph Hellwig <hch@lst.de>
Subject: Re: [PATCH v2] xfs: exercise a failed CoW conversion during writeback
Date: Mon, 28 Sep 2026 18:24:42 +0200
Message-ID: <20260928162443.352542-1-parri.andrea@gmail.com>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260928154149.GA6253@frogsfrogsfrogs>
References: <20260928085047.7250-1-parri.andrea@gmail.com> <arprh9oyZEXs25CQ@zlang-mailbox> <20260928154149.GA6253@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

On Mon, Sep 28, 2026 at 08:41:49AM -0700, Darrick J. Wong wrote:
> for ((off = 0; off < (blksz * nr * 2); off += (blksz * 2))); do
> 	_pwrite_byte 0x59 $off $blksz $SCRATCH_MNT/file2 >> $seqres.full
> done

That's nicer, no loop counter at all, and it writes the same eight
ranges as before.

Zorro, if you're folding the fix in at merge time, please use Darrick's
version rather than the rename I suggested earlier, i.e.:

@@ -48,11 +48,8 @@ _cp_reflink $SCRATCH_MNT/file1 $SCRATCH_MNT/file2
 
 # Dirty several widely separated ranges of file2's CoW extents so that a
 # single writepages() call has to submit more than one ioend.
-seq=0
-while [ $seq -lt $nr ]; do
-	off=$((seq * blksz * 2))
+for ((off = 0; off < (blksz * nr * 2); off += (blksz * 2))); do
 	_pwrite_byte 0x59 $off $blksz $SCRATCH_MNT/file2 >> $seqres.full
-	seq=$((seq + 1))
 done
 
 echo "Inject wb_cow_convert_error"

Again, happy to send a v3 with this if that's easier.

Thanks!
  Andrea
