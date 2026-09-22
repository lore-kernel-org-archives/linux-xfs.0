Received: from mail-wm2-f12.google.com (mail-wm2-f12.google.com [74.125.225.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 78CB1524AE6
	for <linux-xfs@vger.kernel.org>; Tue, 22 Sep 2026 09:10:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=74.125.225.140
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790068220; cv=none; b=ngrmSTLLTOwSG7NLx6DMajqAXM+gnFDoPZVjbkV0OJ6+siYC2d2wXjXmXdoXLIPv7otnbIkrtjG6TloKfdlmJOa1GGrrgDOpuXtBXVH9FAebJme85gRC57odDeL5HwHBD46WlF/3ZtRSVSDrZavx3OIIBIvXZLXz0AA2xnybHTI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790068220; c=relaxed/simple;
	bh=wkOW124WuFQQCipMuwELLw27Qx4x1bj/S8RRLSKncZk=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=bsrgVaeeQJqvpnPnpasgjn+wpSEihushofnlr4lM4oQT31xYdtkAIviGa9yaC9487hKO4DmgBZfpgms5Lf3wFQdQwg95HVLvW9zGOJMkvi0gsC/QIU6wNU/vym7DrLA9/Iz9ulWJMNUAh71XuOQN9zmheFuDHwW/FW+6QreZLGw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=qGY+AXxt; arc=none smtp.client-ip=74.125.225.140
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="qGY+AXxt"
Received: by mail-wm2-f12.google.com with SMTP id 5b1f17b1804b1-49ccff31419so32915555e9.3
        for <linux-xfs@vger.kernel.org>; Tue, 22 Sep 2026 02:10:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1790068216; x=1790673016; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=95n40ZP9Z6iTAIldKB90q2CM8xGRzAwUON6dqMEGMLY=;
        b=qGY+AXxt7623LzERg/mEE6+Ms7RT/rJ3c4pQ6qIeCUP/sUVfnkqW3bjYHDjkr45pwr
         zH1JbgnOgOdVafF0n+Bf8PnKUf5wR8pc3AOoREg2mslfPW5YQG9yuLde870ytLkWVTjQ
         JgIbaxrTrFpvt+IJhtMV7Y+SxYGznJNGW27XYYTS5PertN0ho2CZSU0aNLqVzOPMcu3w
         K/aDKu4JlDeFFd4QnFRZTVX9NH3lt9fhDrcLWggaMsnDP8uH4c44bHz75iEhep1s6cDg
         hlqEAzSwHoFO7czr2kOTEZGzfvDfum/gMjMzEzq7zsdG/KsmWoNj1p0RHihsNZXqgyQr
         R/qQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1790068216; x=1790673016;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=95n40ZP9Z6iTAIldKB90q2CM8xGRzAwUON6dqMEGMLY=;
        b=k86I3Y6p5roG5zsK4fx+kE7Ob7iRPm0GfSKU9xCfn7AdeRJFhyrtMmJQvUJLpQDBxF
         G5IFYQuundhEwDttturD3f9EIYI/eQtksxHOYx6gJh5awtRKM3pOw0U9nzye5rQyCJpm
         7xjNICoHvR7EvbDFYpSKW5QlnEPjqZy/odq4m1BcpKN5CF6fQYPwUMWgWuzYnwc9aTdC
         AAjDiAjt8ey9d2+iwMeUj6E3/X3C0M+kcc+vgNOQ6xa4LZiJWD0y7XEDiBEVqs0k4j5S
         Ulr4idU1FUqT2yr4Ui0GPHzo0HWlU5HsfuZufF8YkBQ3/aCV7xtFvIe6Xqkb21FpU9OC
         8SkQ==
X-Forwarded-Encrypted: i=1; AKwUvBwzpbAgBb/TduRiuz+P5gJZfEpkrAcZ50ogCTA12XOcAH0hPxXZOtWrt/ipDi/xMHqf2hj+kBka/As=@vger.kernel.org
X-Gm-Message-State: AFuF++knlLuDo6B181afupUFxCerQDsHzP6qqb/k65SE32GO0jWFKGid
	kxrse/W/BhccNLBMJ94EPnkP6uak3gIp9AZFw8Dc9o/n4t8JS5KLh4bE
X-Gm-Gg: AYBFou2++znezNsRASqaYE2yjp5+Ibm4iO+kF87TXoroWr8nguUu0ceVn2r4njT1JCQ
	9YOEunbD6ZKIfgxrYBxUAc8noTHiVHPxf/5uuH29dNloCN/9tmu20H2dIyo0x/vGPV3Jlgub5DT
	TcXRGFepVnFLCqoFpwliU8wV8byd7Y1RrybD2F3gEGm80MxvNIr43BVhwAYqAwBH2sI9UjwEW5o
	kUHKrRpPHCgulhsSMfLuFPqxTHufqlEPJvJKVunS4b7wcXyPlKfIjtrt2vvx4NSP2/BnKMguEO4
	zhVvC9ADnYbxRK/Qq3TFFJeVabn2eN+WekgufmyIjo8iShpXDaVanGCKMKjIZDPGevi/+DfC/nC
	VIX3haM9taiNPZD249LTaKiJRaphj0Jjzgxl6xK1JFO8PvlseG6ItdVtW738Tm2CTuXcISm7LnQ
	ut6wDlkw4hdVjtloSOLmj33asnkHJjngK6B9YKpEmtaXyVV2ow4WOooeTdMwgCioZoJjycnAoOh
	GmC98UwJdsa8Mt6HBkZs7O8IMsWbkVeZ2WKZs2d9ULhJBavOU/FZwGQz/uoP+BzkOoDhGpPhSMh
	rf3w
X-Received: by 2002:a05:600c:4e16:b0:49e:8377:c880 with SMTP id 5b1f17b1804b1-49fc574a641mr164997875e9.33.1790068216048;
        Tue, 22 Sep 2026 02:10:16 -0700 (PDT)
Received: from andreayoga.localdomain (93-42-14-189.ip84.fastwebnet.it. [93.42.14.189])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-49fda8f04f7sm57710925e9.0.2026.09.22.02.10.14
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 22 Sep 2026 02:10:15 -0700 (PDT)
Date: Tue, 22 Sep 2026 11:10:13 +0200
From: Andrea Parri <parri.andrea@gmail.com>
To: Christoph Hellwig <hch@infradead.org>
Cc: "Darrick J. Wong" <djwong@kernel.org>,
	Christian Brauner <brauner@kernel.org>,
	Joanne Koong <joannelkoong@gmail.com>,
	Brian Foster <bfoster@redhat.com>,
	Damien Le Moal <dlemoal@kernel.org>, Hannes Reinecke <hare@suse.de>,
	Daniel Gomez <da.gomez@samsung.com>,
	Pankaj Raghav <p.raghav@samsung.com>,
	Dave Chinner <dchinner@redhat.com>, linux-xfs@vger.kernel.org,
	linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
	stable@vger.kernel.org
Subject: Re: [PATCH 3/3] iomap: don't lose a failed direct I/O bio's error
 when zeroing the tail
Message-ID: <arJF9USiUqIEWB1M@andreayoga.localdomain>
References: <20260921083133.2960-1-parri.andrea@gmail.com>
 <20260921083133.2960-4-parri.andrea@gmail.com>
 <20260921223432.GO6283@frogsfrogsfrogs>
 <arIT5A3MR7VtCeba@infradead.org>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <arIT5A3MR7VtCeba@infradead.org>

> > Why ssize_t?  iomap_dio_zero returns int, right?
> 
> More importantly iomap_dio_zero can only return an error for a
> logic bomb assert using WARN_ON.  I'd suggest to simply return without
> an error there and remove the handling of the iomap_dio_zero return
> value entirely, as it clearly casues more harm than it helps.

Agreed, that's cleaner than retyping the local.  I'll drop the
zerror/ret handling entirely for v2 and just call iomap_dio_zero()
without capturing its return.

Darrick, that also answers your question, the type mismatch goes
away since there's no local variable left.

Thanks!
  Andrea
