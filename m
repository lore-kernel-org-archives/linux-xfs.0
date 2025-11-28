Received: from mail-qt1-f171.google.com (mail-qt1-f171.google.com [209.85.160.171])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 510101C861D
	for <linux-xfs@vger.kernel.org>; Fri, 28 Nov 2025 01:33:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.160.171
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764293617; cv=none; b=igsex2M6xaAJ1A66tquMvkiKkOUZaw/BccqbjnLGoyaf3hlrdUNt1IbYvyBl3WqO7EEt1FWCu1kYAuoMClzICvMTnzXHSDYNNIaOfmv9a+3FBj/pJ66NMSQbE56CZufoU4F7YOy7fLetN1cRoFOgld0HSlbpy2NVEWYYdUMsCHQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764293617; c=relaxed/simple;
	bh=uW7r4RZeddBNz8cscDewEXSV9y5trmetenOT44ENLvk=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=V/oUFOBGF0D1llvJZARKXyJweJO1JQSHP1LNwefOyQEZ/82L7We3Bv0DjRZcj/L/bGb1wJyPQ8B02cXDVCmu1Y+Esx13OTam/egi984NWydNX9TLbxLKIp7hgx0pi/m6rZ+S6QWYv4evH/B/6X/KYffz8DKgf9kv9IZl5PGN9JY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=AwMHRMb4; arc=none smtp.client-ip=209.85.160.171
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="AwMHRMb4"
Received: by mail-qt1-f171.google.com with SMTP id d75a77b69052e-4ed7024c8c5so10702161cf.3
        for <linux-xfs@vger.kernel.org>; Thu, 27 Nov 2025 17:33:35 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1764293614; x=1764898414; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=OCmoVsJTYhvhdEhqnCuQdxLwDfWSRN4iQRhiwDtzkSM=;
        b=AwMHRMb4r0mGd3gA2xi7H5T4pl343UxVkWjPc+Gpb0Y53VB0zRTRoMLiEwL0P1xQ/n
         UPYEF+viyxrxa0E1x67z4i7IG9BZtNQav0AVMLsx+uhYv/nBs51FRYM9eUXHGKIPCg34
         QUuxLZ/0a9PAGrxqY/fZDOftRLYXM7GVBzGZggq0A8JOgCj/fd+f9AfmPLpeOE/UTrWw
         hG8xK/lpo5oXn0edVwdnxzIO7xmQ2t9TTUYlEwYlEM9gcr19iVEoU0dKGDVLt+chTwft
         PT5K+/5ZsToq4+QBzK4Zxx7pjn8p90upB1W2XH3ZM+k8WigXbZlzL4ew+kOV/LenFf6f
         dbnw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1764293614; x=1764898414;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=OCmoVsJTYhvhdEhqnCuQdxLwDfWSRN4iQRhiwDtzkSM=;
        b=DhIwEqeYct2IAmkQrJ6+RdL8OY4YkQb1Ymi2JpDMQIGMt5wfy4WMjow7c956tFIzp2
         hrjYmX4c48/Vfj8SRGiEQaI0XQH7ScHk5YQ+arcnD9wLMg1MA5mSlQUmfL4L1AbECOeh
         8uz+4bEdS3iWEQoWB79mtTCnOqKCINu07Eac6qHjH+w9G/HaNPZCfiBFMrBk7wZxrsCe
         W0HG+2JlcbZFOZIcwvqtaiLyWLcGJM/3gRY7Jq3QGtfiNRuG8CImccLn03Pyw2c4r8EL
         MLAPR3emnhXFiTOgzvuGR5EvrfmbFtgyYo1pJtHQ7TKa24W3g4wl4fZZXusoRFV4S1RW
         gHTw==
X-Forwarded-Encrypted: i=1; AJvYcCW8RMZGX//gjyoSNEztd8TFvgw3QOdYvrL0l3490DPa6u3dHrk5qg1Y7iZ0rzfPEpyw1EB2TPpZ3e0=@vger.kernel.org
X-Gm-Message-State: AOJu0Yx/8OcEryFc4pzLuYaH/mRZA1tdLHiVUvnc+8lpdmE6boMqJuDF
	rhTkt44ecPsice5sGMvHEuJL58uicynC9HTHZeRYRGjabBV9rQnmecaP0Rlh+WBbDUBLiwJ1dbJ
	ORBRb/lr9dSAp2b4C8E+TMBAMb1MRrQw=
X-Gm-Gg: ASbGnctTvZpSzWSvkw7a/aMFzntcABkNfwbKEyDRfz+cLk7JVDrS7fy4v2h2Ks0NYnb
	/BLm+sbMval0f2dza825nfPOtwzkY93fw6E3SAxXBo8dB3RbnU+/0yGhnpoXRmS+ik3bdpdd1Pd
	IEz/jfcd5xOJzB8HqV7M+ldXU7RAjSekCFouSsjwUFPzdyZ52Mhm8fTZMKpda4X+XiEGMm4Ry9P
	Y/ppW/I3bL/4eK3KURKnkGdh//WRjpEupG8LOvCdJSN3QWXpT/DOQ3gUx55fcLgqPoW1gs=
X-Google-Smtp-Source: AGHT+IE6nrHo52NkC3u4arv+NV93c/YfHBRAs+svXfCqzbJAogT20JAMk+GOCyu5yn5XMiOUt3k5WhNEc+/7Yy6kmls=
X-Received: by 2002:a05:622a:1a13:b0:4ec:ef6e:585 with SMTP id
 d75a77b69052e-4ee5894f748mr348305511cf.73.1764293614202; Thu, 27 Nov 2025
 17:33:34 -0800 (PST)
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20251121081748.1443507-1-zhangshida@kylinos.cn>
 <aSBA4xc9WgxkVIUh@infradead.org> <CANubcdVjXbKc88G6gzHAoJCwwxxHUYTzexqH+GaWAhEVrwr6Dg@mail.gmail.com>
 <aSP5svsQfFe8x8Fb@infradead.org> <CANubcdVgeov2fhcgDLwOmqW1BNDmD392havRRQ7Jz5P26+8HrQ@mail.gmail.com>
 <aSf6T6z6f2YqQRPH@infradead.org> <3a29b0d8-f13d-4566-8643-18580a859af7@linux.alibaba.com>
 <aShkWxt9Yfa7YiSe@infradead.org>
In-Reply-To: <aShkWxt9Yfa7YiSe@infradead.org>
From: Stephen Zhang <starzhangzsd@gmail.com>
Date: Fri, 28 Nov 2025 09:32:58 +0800
X-Gm-Features: AWmQ_bnqkcJ2TfUO_Hy5DulnmQrOor9Eq1r7gxzBzqTjOKvbRCKHxxHaYPQTzc0
Message-ID: <CANubcdWh0zZpOqhBhWtKf0uN1+8Ec-RsHiSCQUFrqYXoux2-TA@mail.gmail.com>
Subject: Re: Fix potential data loss and corruption due to Incorrect BIO Chain Handling
To: Christoph Hellwig <hch@infradead.org>
Cc: Gao Xiang <hsiangkao@linux.alibaba.com>, Ming Lei <ming.lei@redhat.com>, 
	Andreas Gruenbacher <agruenba@redhat.com>, linux-kernel@vger.kernel.org, 
	linux-block@vger.kernel.org, nvdimm@lists.linux.dev, 
	virtualization@lists.linux.dev, linux-nvme@lists.infradead.org, 
	gfs2@lists.linux.dev, ntfs3@lists.linux.dev, linux-xfs@vger.kernel.org, 
	zhangshida@kylinos.cn
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Christoph Hellwig <hch@infradead.org> =E4=BA=8E2025=E5=B9=B411=E6=9C=8827=
=E6=97=A5=E5=91=A8=E5=9B=9B 22:46=E5=86=99=E9=81=93=EF=BC=9A
>
> On Thu, Nov 27, 2025 at 03:40:20PM +0800, Gao Xiang wrote:
> > For erofs, let me fix this directly to use bio_endio() instead
> > and go through the erofs (although it doesn't matter in practice
> > since no chain i/os for erofs and bio interfaces are unique and
> > friendly to operate bvecs for both block or non-block I/Os
> > compared to awkward bvec interfaces) and I will Cc you, Ming
> > and Stephen then.
>
> Thanks.  I'll ping Coly for bcache.
>

I would like the opportunity to fix this issue in bcache. From my analysis,=
 it
seems the solution may be as straightforward as replacing the ->bi_end_io
assignment with a call to bio_endio().

Thanks,
shida
