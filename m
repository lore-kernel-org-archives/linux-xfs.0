Received: from mail-pj1-f44.google.com (mail-pj1-f44.google.com [209.85.216.44])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8185623BF83
	for <linux-xfs@vger.kernel.org>; Mon,  8 Dec 2025 04:30:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.44
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765168220; cv=none; b=XelA2j4992ICMTkuYRmysQL7pWc92sUoZ8BKCSIqJMGM5fNRn25s216Cer6KnAXJReNjr9ahh1/RdoVzrg17DzCqH0jwRw6XJmJoA6YuFelXDstHfoUmmoCrwFIIRbqrJDATb6nQAwZ44yDftKtvozY5SvNYGo2UldBP0HV50lQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765168220; c=relaxed/simple;
	bh=eZCCvYQToVmBxbAbt2lQE5EqqWAflUIJbtQ4xunVH0I=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=uQt4u3ECWNYPvaB03oLxjob6TKLC+VeD//VRx6Am+IdP6/NbXIIJF9vSYBJX24x4E4AXVZFKTaseHyB8+7cDrGiU4sIssTuJMp4JpJzJV/qVIrPfeNCsX4uO61kLTWBmz2iShAUoh9jv/96T0tyuW8Ce+0WTy2DoxmFW1yRC/Ac=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=fromorbit.com; spf=pass smtp.mailfrom=fromorbit.com; dkim=pass (2048-bit key) header.d=fromorbit-com.20230601.gappssmtp.com header.i=@fromorbit-com.20230601.gappssmtp.com header.b=fLCb6Z/m; arc=none smtp.client-ip=209.85.216.44
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=fromorbit.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=fromorbit.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=fromorbit-com.20230601.gappssmtp.com header.i=@fromorbit-com.20230601.gappssmtp.com header.b="fLCb6Z/m"
Received: by mail-pj1-f44.google.com with SMTP id 98e67ed59e1d1-343806688c5so3113687a91.0
        for <linux-xfs@vger.kernel.org>; Sun, 07 Dec 2025 20:30:18 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=fromorbit-com.20230601.gappssmtp.com; s=20230601; t=1765168217; x=1765773017; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=nv7k4jy894O1RwRGQhzgAtY3y+ajSbQvSL7BZDIaDhU=;
        b=fLCb6Z/m4sdZ2vFhwI/UY6gbxoQqKxK3CpXgwuDkG0jPUvuihHxlK1Oe3q2GjjvKTX
         zLVR68ZEYIh1iuehsFPbzrxRifgvW4AsQeiATW4Cz3CL1uahA+ALYD+L6fON7dxmAQHU
         y30gSJgCj13txiU4nrbNfu8XTnyQ6DDvrfOv3QuKcf+wsMxRcABJmSqSZWMmpRg0NIVI
         flSHsiKyxC24OR6ZwN4M2veA+KcQ0ZtkcEWsEUlndCnqOw+WL4PmoeFikrb1uJ8H347b
         3MPbRouIO/BM+ywObZ4IqM+wdMh+8uyQastR8z3Jn2xv+HyqUcXuw2nr4UvQHnadpTam
         sVRQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1765168217; x=1765773017;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=nv7k4jy894O1RwRGQhzgAtY3y+ajSbQvSL7BZDIaDhU=;
        b=UnS0dYPcABikdcqeI3IYaD71sV40KhHEjtcfBA3PFvQCKnzuJBCNrowhBBC2P59ffC
         FBP8yVec0V7lDfWWOST29lmzWAvk5gSxrF5tS+mecmlWfxSowPWqNlORA1GmZLMw7eqG
         47TEvj1dJ/lxqLUQTLXl8IUxXoNpEpiVTlcmJPSGzm3FLH3jvhwBu+TmvMbZXf6MTIoA
         nzFQUI9BH2Qyt8uwTMOFXdHCKdErKrkNWy/bltrjUBRPUpbEddu8j8gLvZ+D/yo0lUG/
         IKNmsOcs8ll7VuW8zQldE2bn05B5LMiz62fH/q1Lim3QnNByt2HYoxpknzBzwjZPi0AF
         MCvQ==
X-Forwarded-Encrypted: i=1; AJvYcCWu69wNhkbLBfoRY/5Q8qgrCN3epC36qCU2xg+IWUJE7mLgHm9cCgKOftGH4slBtV8tsKYyzDdnMbs=@vger.kernel.org
X-Gm-Message-State: AOJu0YwCVAsl3/38chPNHfKzygfYeALER72xGsFlm/vczEbQCbJgAhe/
	4LUCv5qsJ7pP+kKReHdsmPNBfa/5K4JuhdzizyJAQ5E34Syke/QrmwnbX4bDQr/Xa9nTcIsirtk
	djFYR
X-Gm-Gg: ASbGncuvIHehauFPa0hBXW2Uli0FG7a/RtRZnmUBI5BOcYMGJNePfvBL8Zw5CUTGAYr
	eBWq3EeIQ7qLsR9OuMmU6bPBHqypD3mcu+TaXYf+yqNCFr/7UqRyz+WXF9JV8q+AhMhrkFSfrdk
	8OPRGql2hQthKGaiFRB8LPWy1memPkauuzm9bbX28gYil9JU7AbUuWw/ESyhEy48jqCUuH2FeMg
	WHiOEId60ACQbxBvdhOYZQkJ22riAlrEEAfOgrY5ThZPc16wD84baL6MWX2EC6ycB+WeC7wbQse
	jhK5yTzn7sEhLkYBSkufZnnRoZgjnBX4Ng1ledCMiT5dOkeIYx0Ki1cAR7aaGiPToAAHaMP8/ns
	GgXC3NYfXOR6YoJAhMJsxxD34zFEnRXq0GxrSCms3VScpe70ACOGwWRuWGM3H/VRbYY5h/BiKIb
	h1RLSPjl8YYtPQPOvS+HGqTAKOfOrk5qiU0cjGd4u9SBJTuDflh/S4Qwhja9A=
X-Google-Smtp-Source: AGHT+IFI/TFbhGZUTQnCDv2NnMnyA+B0AiJlnGhcyEr8Y2P8DlMdwc11rta+EgURcc0IcYEdkdwp+w==
X-Received: by 2002:a17:90b:3b92:b0:340:4abf:391d with SMTP id 98e67ed59e1d1-349a250c3acmr5117256a91.16.1765168217118;
        Sun, 07 Dec 2025 20:30:17 -0800 (PST)
Received: from dread.disaster.area (pa49-195-10-63.pa.nsw.optusnet.com.au. [49.195.10.63])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-3499ddae025sm2628066a91.5.2025.12.07.20.30.16
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 07 Dec 2025 20:30:16 -0800 (PST)
Received: from dave by dread.disaster.area with local (Exim 4.98.2)
	(envelope-from <david@fromorbit.com>)
	id 1vSSt3-000000009e7-39of;
	Mon, 08 Dec 2025 15:30:13 +1100
Date: Mon, 8 Dec 2025 15:30:13 +1100
From: Dave Chinner <david@fromorbit.com>
To: Christoph Hellwig <hch@lst.de>
Cc: "Darrick J. Wong" <djwong@kernel.org>, Carlos Maiolino <cem@kernel.org>,
	linux-xfs@vger.kernel.org
Subject: Re: [PATCH, RFC] rename xfs.h
Message-ID: <aTZUVTH4pMITncqc@dread.disaster.area>
References: <20251202133723.1928059-1-hch@lst.de>
 <aTFOsmgaPOhtaDeL@dread.disaster.area>
 <20251204092340.GA19866@lst.de>
 <20251204172158.GJ89472@frogsfrogsfrogs>
 <20251205081224.GA21377@lst.de>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20251205081224.GA21377@lst.de>

On Fri, Dec 05, 2025 at 09:12:24AM +0100, Christoph Hellwig wrote:
> On Thu, Dec 04, 2025 at 09:21:58AM -0800, Darrick J. Wong wrote:
> > > Fine with me if that name is ok for shared code.
> > 
> > Why not merge the xfs_linux.h stuff into xfs_priv.h?  It's not like xfs
> > supports any other operating systems now.
> 
> We should merge them anyway, but I understood Dave in that he preferred
> the xfs_linux.h name over xfs_priv.h one.

Yeah, that. It's really the include file for the platform specific
definitions, not anything "private" to XFS. If we want the same name
for userspace and kernel, then maybe xfs_platform.h is best, and
userspace can then include whatever OS/library specific platform
headers it needs from that.

> I don't really care either
> way, I just don't want to redo the patch too many times.

*nod*

-Dave.
-- 
Dave Chinner
david@fromorbit.com
