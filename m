Received: from mail-pl1-f177.google.com (mail-pl1-f177.google.com [209.85.214.177])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1341A13A88C
	for <linux-xfs@vger.kernel.org>; Thu, 15 Feb 2024 21:45:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.177
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708033554; cv=none; b=c13lLUkkrCHavu3GD/ZRGNhi6HkrGn9r8TxS1SJ5vGylnX36/v51lBVAXgWi4GUl+3o+esdVC8X/olviDtRnChPpWK+0UcljdBVTv34gmfqj5FfUJKn9BnXXWou9Hu2NNrPB/tKIgz3MhiFYKBa8aTeiOHtGt88EU6zdeBFYaqk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708033554; c=relaxed/simple;
	bh=8FhN1piRO+qNGVcAfy/8iLtBYzR2KChU3hXAO1Rh2qc=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Cu+M93Txv+Yx9E+4/pHaCJVO7xWzYN4Bndto7iIegP8tEIBPnfsbG3ocAjOURneHDIXYsuuFuURaaYmWIxODLUghcj/T5JMly5m9r05uxNxfziehRzsb5v+O845OrOiqsigcfSiOKHuZn3XvD8jlRub9EU/dgiZRFFMw4mOrOdM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=fromorbit.com; spf=pass smtp.mailfrom=fromorbit.com; dkim=pass (2048-bit key) header.d=fromorbit-com.20230601.gappssmtp.com header.i=@fromorbit-com.20230601.gappssmtp.com header.b=tcR1QZ8b; arc=none smtp.client-ip=209.85.214.177
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=fromorbit.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=fromorbit.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=fromorbit-com.20230601.gappssmtp.com header.i=@fromorbit-com.20230601.gappssmtp.com header.b="tcR1QZ8b"
Received: by mail-pl1-f177.google.com with SMTP id d9443c01a7336-1d7354ba334so12205415ad.1
        for <linux-xfs@vger.kernel.org>; Thu, 15 Feb 2024 13:45:52 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=fromorbit-com.20230601.gappssmtp.com; s=20230601; t=1708033552; x=1708638352; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=nxJxihJMTy/upJu6YimBZRR9IzVm6H0zipBB9BI3WRE=;
        b=tcR1QZ8byi2tBNKRXt4sqKHqniMsqtXDX0KR1ue7pzkQOqRyDk5ezn8RFeGiPRYpHD
         DTzYEbyn314E1sVEbIk8vb0axo8b3xEchWKFBuNmVg9If0GQOacIF1M/zv4RBfbhb4Y0
         AZ1uVX0MoDx02o+JCyUziJrSTmyMIDwPuJ2W5psSo/BdWmNzajcs/JgP6wxcPKrzdGZa
         tuhmUep15OAFH5/jOJ86x2uWJwhQWwDOz/5Au6ATqXt1k2eP1HsX9QgkG8ttcQ/q1KGL
         Lhhcoqm0sJkk0YdieWMfQY1wzhrJgxAuUq2nCroiauCAK4IzfgtxP5XcuYY2Hkq0ijpK
         RZGQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1708033552; x=1708638352;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=nxJxihJMTy/upJu6YimBZRR9IzVm6H0zipBB9BI3WRE=;
        b=nJnA11HzapNNLF7IjKK/vCzEo8czI4NI+5khjuGxIokxTI/22f+vxQtI+ix2NIg3qK
         CW9sHMMmOlaIvQ0wPOaf5p1orM8NNREIFEhxFlnZdrMSGkJtzu5UTktU3ImSu3GkK7cK
         PvKjggR4y+EVBdRS4y8VBcC0Vf6u08VZCYkKhqKUauiaxJsgQrK0kn7mB0PZX/Moaye9
         aFI52N9c1ZVO9zNTZLz3M22KaE1DOCWrt3JIP8TmVkaB9Hlx0YU3uuOdYzq7gBahGXqE
         yr8TA8p1p1LmFBDJl3eZ4rTLHinM/3F2t2VgNrdaZzd/b3GvqkQ6WpUTKen/Zdd90LQz
         lzHA==
X-Forwarded-Encrypted: i=1; AJvYcCVEKBwM5q+iL//sECVqn6Ox0PZ3uXgm59oLAezOyI5i+GpSFn726cHOSEQ9PA42Fjks388eataL2tZqzK+VA9g1uIN8xsyeZ3Af
X-Gm-Message-State: AOJu0Yy/s0E8cPDN8rqeaEeRt71GbE/iehwg20wHGT61cbeN71D1ZLp/
	ejaI8Bk8dpNA8LGwFtjvfwO/9W/G6zJhJuwc2D8ft6DbxPvkkc07w9jz7YL0jH8=
X-Google-Smtp-Source: AGHT+IGQyuztc0zvzAlIu/JDwRarnXYZyEyvkM2nAedgYMUvv4G9gL0zNUUWeBt1b239+idkRJTB3w==
X-Received: by 2002:a17:902:d487:b0:1d9:9774:7e8a with SMTP id c7-20020a170902d48700b001d997747e8amr3703431plg.24.1708033552380;
        Thu, 15 Feb 2024 13:45:52 -0800 (PST)
Received: from dread.disaster.area (pa49-195-8-86.pa.nsw.optusnet.com.au. [49.195.8.86])
        by smtp.gmail.com with ESMTPSA id r10-20020a170902c60a00b001db817b956bsm1712355plr.259.2024.02.15.13.45.52
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 15 Feb 2024 13:45:52 -0800 (PST)
Received: from dave by dread.disaster.area with local (Exim 4.96)
	(envelope-from <david@fromorbit.com>)
	id 1rajYC-0070eA-2m;
	Fri, 16 Feb 2024 08:45:48 +1100
Date: Fri, 16 Feb 2024 08:45:48 +1100
From: Dave Chinner <david@fromorbit.com>
To: Andrey Albershteyn <aalbersh@redhat.com>
Cc: fsverity@lists.linux.dev, linux-xfs@vger.kernel.org,
	linux-fsdevel@vger.kernel.org, chandan.babu@oracle.com,
	djwong@kernel.org, ebiggers@kernel.org
Subject: Re: [PATCH v4 06/25] fsverity: pass log_blocksize to
 end_enable_verity()
Message-ID: <Zc6GDNMj3gAk20nc@dread.disaster.area>
References: <20240212165821.1901300-1-aalbersh@redhat.com>
 <20240212165821.1901300-7-aalbersh@redhat.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240212165821.1901300-7-aalbersh@redhat.com>

On Mon, Feb 12, 2024 at 05:58:03PM +0100, Andrey Albershteyn wrote:
> XFS will need to know log_blocksize to remove the tree in case of an
                        ^^^^^^^^^^^^^
tree blocksize?

-Dave.
-- 
Dave Chinner
david@fromorbit.com
