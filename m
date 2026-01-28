Received: from mail-pg1-f194.google.com (mail-pg1-f194.google.com [209.85.215.194])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6C49421FF30
	for <linux-xfs@vger.kernel.org>; Wed, 28 Jan 2026 15:25:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.194
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769613936; cv=none; b=BvO6giD03+FinwK7kdddRILHyKK4v+RQiVo6RlF8wkHCVGuMR2/U4TAXWvGgGa/p4HqAaNk5s6ctjSTs2hXiMWnYweMv1aT93zjIa/dIK5IBiMe+UlUFYOl08FsdEQHoBdv8hQ6ftf/cYitu2RRk7T5x2T6902DO8L8Zdi/U4mo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769613936; c=relaxed/simple;
	bh=fxTMbrMy4hr2Hv4agPCS+JOamsxKNmpaEDJNyIf2NGM=;
	h=Content-Type:Mime-Version:Subject:From:In-Reply-To:Date:Cc:
	 Message-Id:References:To; b=IIvNoQvesPBj8DG9236gSz9hv+svrwsV3gQHPGMXyc1MJuQV4JgkCgN6CibkGDNAJ4LWtym6TQDxfFjTeOP+GcJRcaIoTDw31M9xwEeyqlQ8Khl1hIK6AST9OnwzZ9sofNAD09myNEqMQyZtyRNYrdRc8g6kgBj7EyrJw/b+1w4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=mufMWncI; arc=none smtp.client-ip=209.85.215.194
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="mufMWncI"
Received: by mail-pg1-f194.google.com with SMTP id 41be03b00d2f7-bd1ce1b35e7so4423646a12.0
        for <linux-xfs@vger.kernel.org>; Wed, 28 Jan 2026 07:25:35 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1769613935; x=1770218735; darn=vger.kernel.org;
        h=to:references:message-id:content-transfer-encoding:cc:date
         :in-reply-to:from:subject:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=fxTMbrMy4hr2Hv4agPCS+JOamsxKNmpaEDJNyIf2NGM=;
        b=mufMWncIsZgxjRCmeZBlOX2VBgHT6b7c5ljPqzosFEPBRmFZfgyZKb4UEQ//Kocgne
         u4ieO9ByM5h4/BHWxGprTvcf7HxNWa8jiASx5wswZn0IBSKMAbWCtrTTBQSBua7y9HL9
         HN8m5JfY06F4uXb+Uz+R8rJapiJMHlg7wWPyzJRalm2CNU8AHVzrq5cJQ1EOaR2kxybc
         74+Nfwtg8UD4XwzPPq54kfi6yaQuphDachxGpROFpWyQHYg6K/kOtiUeCgQVjgHs29Ra
         sLyeexQclpSZdrOc1Ec/TJG9b4XEmkshdATQ9o3Ux3Eo2llUExTKW8JuZovI9TyMNvCy
         VIlA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1769613935; x=1770218735;
        h=to:references:message-id:content-transfer-encoding:cc:date
         :in-reply-to:from:subject:mime-version:x-gm-gg:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=fxTMbrMy4hr2Hv4agPCS+JOamsxKNmpaEDJNyIf2NGM=;
        b=DT/1O+cW1jxNZoRzf7CeEz0U8xyxPIERRfPsUYs4LOiQ8pNaKbEhPgMmx97mDHMze1
         Th6fH3jovXSDORBMRKM0HRyv3Sxj6hcByRna+lOx2lLwhtPIW2r+ifk0XonzlQABUNCQ
         IdbKYg9OZ4NMHdy/6BJnJLEJlF6IHfv0TbyasM5ODj+xiw3IjIPk1oXIwREFHfnmxogJ
         01zolg7uyoW5MzHa7kE3kIoMABRrDJb6OA4fOx45eR4xzXgDMZgB/9B4ENFe2G0WGZfu
         saZehdqMkXwFTox1jLHXEAdRgtJym88xxdzU4MS4pSKfxojCEXratkKBlrTk6dy6DZUD
         9l0w==
X-Gm-Message-State: AOJu0YykaYrEhxwhz1huWl/KFudX/RKQr5y5h98DqCLd1gfrT+bd3Biq
	TponCNumZaAfdvDCk6gPrbo2vdgTu+i83K8Uom6xzqcqxgXpT8SZRTW/Qgx7MvAwZ+Q=
X-Gm-Gg: AZuq6aIzIs6fhp/rNwbKIcmgQemKmfBn71w1TEYlkXhCg0pjb0M1CdYsjlCKC+CunPk
	bK+6WmBJHdzZj3Ll/qbAGwzm8HfIvoYHspGbRurgtoyg/tJY5ZyEYzsCQtqQK01DXurUxuwRu+F
	T/XjP2aThF14RSIq5EgH+GhlPCV13thnVZk5XbBOpg78Nd4q1RCS8RfiWYuHBxS7tHa/5rw4E4H
	DT/DjZnz1T1fJRWW+wm5KMNtwNTNc3KztsytLL+NxEVmJ/jbJJ1gNLWnTu8pPkT0ZEGFKNysE1p
	dYG3rf4nVqi+SHsL8sBBHsc+mOgZ/T6tfeyPItky6YG1rhhuGwXxTIFY9PbctTuw4cKWJvdo6Cr
	//zPSDYRwSR/uxrqJW+iW5s95xDvu6+2WL5kIiE+ibArdb3Txki5W4KZZJdgOhYdkUnNk2Q==
X-Received: by 2002:a05:6a20:2d23:b0:38e:9d15:afb7 with SMTP id adf61e73a8af0-38ec633904cmr5300791637.22.1769613934590;
        Wed, 28 Jan 2026 07:25:34 -0800 (PST)
Received: from smtpclient.apple ([2402:d0c0:11:86::1])
        by smtp.gmail.com with ESMTPSA id 41be03b00d2f7-c642afbffdfsm2479073a12.34.2026.01.28.07.25.30
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 28 Jan 2026 07:25:33 -0800 (PST)
Content-Type: text/plain;
	charset=us-ascii
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
Mime-Version: 1.0 (Mac OS X Mail 16.0 \(3864.300.41.1.7\))
Subject: Re: [PATCH v1 1/2] xfs: Move ASSERTion location in
 xfs_rtcopy_summary()
From: Alan Huang <mmpgouride@gmail.com>
In-Reply-To: <a904c5bcb5b4fc2c7c2429646251a7f429a67d5a.1769613182.git.nirjhar.roy.lists@gmail.com>
Date: Wed, 28 Jan 2026 23:25:17 +0800
Cc: linux-xfs@vger.kernel.org,
 ritesh.list@gmail.com,
 ojaswin@linux.ibm.com,
 djwong@kernel.org,
 hch@infradead.org
Content-Transfer-Encoding: quoted-printable
Message-Id: <AFEDD069-01DE-4DDF-B499-9B2C2C3F8778@gmail.com>
References: <cover.1769613182.git.nirjhar.roy.lists@gmail.com>
 <a904c5bcb5b4fc2c7c2429646251a7f429a67d5a.1769613182.git.nirjhar.roy.lists@gmail.com>
To: "Nirjhar Roy (IBM)" <nirjhar.roy.lists@gmail.com>
X-Mailer: Apple Mail (2.3864.300.41.1.7)

On Jan 28, 2026, at 23:14, Nirjhar Roy (IBM) =
<nirjhar.roy.lists@gmail.com> wrote:
>=20
> We should ASSERT on a variable before using it, so that we
> don't end up using an illegal value.
>=20
> Signed-off-by: Nirjhar Roy (IBM) <nirjhar.roy.lists@gmail.com>
> ---
> fs/xfs/xfs_rtalloc.c | 6 +++++-
> 1 file changed, 5 insertions(+), 1 deletion(-)
>=20
> diff --git a/fs/xfs/xfs_rtalloc.c b/fs/xfs/xfs_rtalloc.c
> index a12ffed12391..9fb975171bf8 100644
> --- a/fs/xfs/xfs_rtalloc.c
> +++ b/fs/xfs/xfs_rtalloc.c
> @@ -112,6 +112,11 @@ xfs_rtcopy_summary(
> error =3D xfs_rtget_summary(oargs, log, bbno, &sum);
> if (error)
> goto out;
> + if (sum < 0) {
> + ASSERT(sum >=3D 0);


Does the ASSERT make sense under the if condition ?


> + error =3D -EFSCORRUPTED;
> + goto out;
> + }
> if (sum =3D=3D 0)
> continue;
> error =3D xfs_rtmodify_summary(oargs, log, bbno, -sum);
> @@ -120,7 +125,6 @@ xfs_rtcopy_summary(
> error =3D xfs_rtmodify_summary(nargs, log, bbno, sum);
> if (error)
> goto out;
> - ASSERT(sum > 0);
> }
> }
> error =3D 0;
> --=20
> 2.43.5
>=20
>=20

