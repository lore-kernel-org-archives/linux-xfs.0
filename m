Received: from mail-ot1-f43.google.com (mail-ot1-f43.google.com [209.85.210.43])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DE2F854648
	for <linux-xfs@vger.kernel.org>; Tue, 27 Aug 2024 11:03:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.43
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724756619; cv=none; b=VRR59EHuPtwvtfAvqNy2jtHG4XQbhleVQQjvNKeC6LO5mlCEeECGvAy2Y5KJr4t6osDXMwo9pD3cQElbOvPWmoujs8h96fmsMiokY8+7iVeJoLFb1vT6+XPII4jm+ZcpccLINm3Psx5936LrCZTZG1bjSaphK6Q5RFlg36j9T+c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724756619; c=relaxed/simple;
	bh=xvZII4caJcgeweZF6xeJaPYQ9qDMCjswfFfgR+4FA88=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=ckEeNzF+xA3vi84EOsC9etENX/kaNC5XfXdAJMSKdneOLkDvos1fD/P8PupEL9WRA259tPbDpatXnV08UQcYyjlx2eSxleHjhDfL4M0umikeIgaBox2xWybBafDSLMQi05A+xJs0S0oKsLZd71dYta7J4NyZhT/9oUAMAFa9GIk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=toxicpanda.com; spf=none smtp.mailfrom=toxicpanda.com; dkim=pass (2048-bit key) header.d=toxicpanda-com.20230601.gappssmtp.com header.i=@toxicpanda-com.20230601.gappssmtp.com header.b=IgFW6yYU; arc=none smtp.client-ip=209.85.210.43
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=toxicpanda.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=toxicpanda.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=toxicpanda-com.20230601.gappssmtp.com header.i=@toxicpanda-com.20230601.gappssmtp.com header.b="IgFW6yYU"
Received: by mail-ot1-f43.google.com with SMTP id 46e09a7af769-70941cb73e9so3324489a34.2
        for <linux-xfs@vger.kernel.org>; Tue, 27 Aug 2024 04:03:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=toxicpanda-com.20230601.gappssmtp.com; s=20230601; t=1724756616; x=1725361416; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=uQEy8T+wkN9m4LdWnvomQCPHiK5omwEOBZ8H5VISVpg=;
        b=IgFW6yYU0rLSLhTJEYPvVYLGL+RDHctUtvoojqVr3vAZZ4f0+he45o/A3Dq5CaRUEM
         4upYWOse2jKVQtcrTlnhFRR5qjluZ4Hkh8bwB/eY6C5m2IZ4TMbNp6FZxKTbTHDEWqlq
         GRj40FTUhxlsEOK/WvrdXwjuv/ajBUnyFvaFzrnCPi5117nJozJdzN74VkZ0jm8YA19y
         pOAHS1IdiAXvuHGG5dWES4+M5P/sO7aaWLLhCub2KPWtnFd5+e4A6hhNk3EOyKN30IJH
         3NYylReh60wvPNLscGqLS25dFhENj/WpMcmmqA2IZzd/m+GuJfAZz8TYuqIw10w7InG6
         SU+A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1724756616; x=1725361416;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=uQEy8T+wkN9m4LdWnvomQCPHiK5omwEOBZ8H5VISVpg=;
        b=SPPCOeHXqff7a0RoYHbaWXREwNrLn/ZGZyxtMJeJ5oMGGQF7VH+jgTBnzDiQO7iYwE
         dH5oP0icj/n8HNAxgva3Bim7ai56fSpc8tWtn4JGheBkRpaeWKfk3QPLInNopJ2hWqQN
         cw4vak5TbJGrdUyI/ggrBYUWP0hT31QJZuxXFx5dI/1pcePMBT+8bJcc1cXzyheq37PG
         GnHbyOlKAojkB4an+0orFYnOOMRBN2Yl70C/zOGhIG3hVLiemI1DzrwPux20tqh0ZXLY
         H2ts3AN0eBvwPYOPGAaUAs4B9tue77gyQfBki3zjyJ9ftbiOtkWTuACYLEjT9NQvMAbP
         TzMQ==
X-Forwarded-Encrypted: i=1; AJvYcCVnEfRnf1cxetzOG+obYwDDrfXdbYBFdfxg/xb0Njl93ay81SnUHgEsVLQPYA7GW2oP8CUEpzshctw=@vger.kernel.org
X-Gm-Message-State: AOJu0Yymn09yETTr4c/pJTldyL1ZP6iuP2b51x2Rkqnx3qNBJrIL0yq8
	e9nHWvGv+tnC44MuPF0NFAz5Op+3W8p0oSDfNTIDBqZFuvlT/+A7X11VkOTvYkg=
X-Google-Smtp-Source: AGHT+IF4qNHXWkmCySjIoxZw6q+2LEaErol9CphZ5YD0qyPKn6n7vFU0PYNhP5cbC3GrrXP25hlwYw==
X-Received: by 2002:a05:6830:4989:b0:703:6641:cea5 with SMTP id 46e09a7af769-70e0eb37e5bmr16117729a34.16.1724756615938;
        Tue, 27 Aug 2024 04:03:35 -0700 (PDT)
Received: from localhost (syn-076-182-020-124.res.spectrum.com. [76.182.20.124])
        by smtp.gmail.com with ESMTPSA id 6a1803df08f44-6c162d21710sm55059366d6.11.2024.08.27.04.03.35
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 27 Aug 2024 04:03:35 -0700 (PDT)
Date: Tue, 27 Aug 2024 07:03:34 -0400
From: Josef Bacik <josef@toxicpanda.com>
To: Christoph Hellwig <hch@infradead.org>
Cc: linux-fsdevel@vger.kernel.org, linux-xfs@vger.kernel.org,
	gfs2@lists.linux.dev, linux-block@vger.kernel.org,
	dlemoal@kernel.org, djwong@kernel.org, brauner@kernel.org
Subject: Re: [PATCH][RFC] iomap: add a private argument for
 iomap_file_buffered_write
Message-ID: <20240827110334.GC2466167@perftesting>
References: <7f55c7c32275004ba00cddf862d970e6e633f750.1724755651.git.josef@toxicpanda.com>
 <Zs2wl4u72hxRq_VU@infradead.org>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Zs2wl4u72hxRq_VU@infradead.org>

On Tue, Aug 27, 2024 at 03:55:19AM -0700, Christoph Hellwig wrote:
> On Tue, Aug 27, 2024 at 06:51:36AM -0400, Josef Bacik wrote:
> > In order to switch fuse over to using iomap for buffered writes we need
> > to be able to have the struct file for the original write, in case we
> > have to read in the page to make it uptodate.  Handle this by using the
> > existing private field in the iomap_iter, and add the argument to
> > iomap_file_buffered_write.  This will allow us to pass the file in
> > through the iomap buffered write path, and is flexible for any other
> > file systems needs.
> 
> No, we need my version of this :)
> 
> http://git.infradead.org/?p=users/hch/xfs.git;a=commitdiff;h=84e044c2d18b2ba8ca6b8001d7cec54d3c972e89
> 

Hooray I'm not an idiot!  Thanks,

Josef
