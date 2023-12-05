Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=fromorbit-com.20230601.gappssmtp.com header.i=@fromorbit-com.20230601.gappssmtp.com header.b="eKcqfFc3"
Received: from mail-pg1-x534.google.com (mail-pg1-x534.google.com [IPv6:2607:f8b0:4864:20::534])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E7F2E109
	for <linux-xfs@vger.kernel.org>; Mon,  4 Dec 2023 21:41:58 -0800 (PST)
Received: by mail-pg1-x534.google.com with SMTP id 41be03b00d2f7-5c67c1ad5beso1550196a12.1
        for <linux-xfs@vger.kernel.org>; Mon, 04 Dec 2023 21:41:58 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=fromorbit-com.20230601.gappssmtp.com; s=20230601; t=1701754918; x=1702359718; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=5LkJItxrJ+lwE2GilVFYE8r0vCl5EDIzBukJ4WmI2GQ=;
        b=eKcqfFc3mRhM0BlNprDmUKxhQD8+vDDrfShiJnQmDDRaHp3oJX9Z9mYFFsAVdGXRC5
         wOVGW3CGXHIY9/WHaccHE0DhZWc3Hdkn6hX9Fixiql4Er30Gb3/STjY468ONnDpXwEJN
         CAJ6k//1z4IWZ3zTm+Wap6lj2TjbIUXOsvYgKhKk1SUkxlIEV2Z/dVj/iCLAYMAH5QrC
         h02Qg5EaHVm20oQKhIU4X8HTpOakabVfHEcXF5A1bu1uHp4wWbbKikBSQB2OUVNLaYXl
         MEhEYU/PDpMUygkYKUqlilB020d7IfJmGLk2/51lu9XAU1mDH5ftPW1X02HFh3fjhO0L
         meTQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1701754918; x=1702359718;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=5LkJItxrJ+lwE2GilVFYE8r0vCl5EDIzBukJ4WmI2GQ=;
        b=D83EFepZBN+gOrJrRDF0wnS5Yq8VtJeMjzhOIulCkTO9d20dWZPuKX/Gy+hFnSruep
         9CnOw5wcrWtquYkPDzy5k+fuYkaultQc4kkNmLwH9cBHyVw+p8Bovsi7oPb3OaHD9ISD
         tlnTh58cEayLf6zSe3BO3HtWDX56ugUJ5P6+Wn6owXWzG1fn7rEr2bA57cyj3WT5aqrl
         8oNHRyshlO4TxOP6DDp+Qg7mENpMvXnnEO0NDLVqziKGRQS/md85CbAbh0/+Df94w9rn
         w5om+BSug9tinifT+EpHbTu8R4pv+KUcWRKwMLY7Y8uvrfWbo7TJcL2bjacDsqPTpyyX
         7UJw==
X-Gm-Message-State: AOJu0Ywc+iQ9nLmYdwBrTZMY8+HAtPuIGvZSWvhd72PBJQ3qW/sc6a9A
	F2S4o4KrlbsEcG5Kc2vvWEwasA==
X-Google-Smtp-Source: AGHT+IH0ywUoLoprkwipF7mi5yUXZUCAdnhGi10wGkQghXLT+sihi84LAxxzzvQGhWVSdw7d6TdMiQ==
X-Received: by 2002:a17:90a:eb07:b0:286:6cd8:ef15 with SMTP id j7-20020a17090aeb0700b002866cd8ef15mr966267pjz.45.1701754918273;
        Mon, 04 Dec 2023 21:41:58 -0800 (PST)
Received: from dread.disaster.area (pa49-180-125-5.pa.nsw.optusnet.com.au. [49.180.125.5])
        by smtp.gmail.com with ESMTPSA id w19-20020a17090aea1300b002858ac5e401sm5319404pjy.45.2023.12.04.21.41.57
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 04 Dec 2023 21:41:57 -0800 (PST)
Received: from dave by dread.disaster.area with local (Exim 4.96)
	(envelope-from <david@fromorbit.com>)
	id 1rAOBv-0043D2-0k;
	Tue, 05 Dec 2023 16:41:55 +1100
Date: Tue, 5 Dec 2023 16:41:55 +1100
From: Dave Chinner <david@fromorbit.com>
To: bugzilla-daemon@kernel.org
Cc: linux-xfs@vger.kernel.org
Subject: Re: [Bug 218226] New: XFS: Assertion failed: bp->b_flags & XBF_DONE,
 file: fs/xfs/xfs_trans_buf.c, line: 241
Message-ID: <ZW64I2Ol+5FCXJG+@dread.disaster.area>
References: <bug-218226-201763@https.bugzilla.kernel.org/>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <bug-218226-201763@https.bugzilla.kernel.org/>

On Tue, Dec 05, 2023 at 03:22:44AM +0000, bugzilla-daemon@kernel.org wrote:
> https://bugzilla.kernel.org/show_bug.cgi?id=218226
> 
>             Bug ID: 218226
>            Summary: XFS: Assertion failed: bp->b_flags & XBF_DONE, file:
>                     fs/xfs/xfs_trans_buf.c, line: 241
>            Product: File System
>            Version: 2.5
>           Hardware: All
>                 OS: Linux
>             Status: NEW
>           Severity: normal
>           Priority: P3
>          Component: XFS
>           Assignee: filesystem_xfs@kernel-bugs.kernel.org
>           Reporter: mcgrof@kernel.org
>         Regression: No
> 
> While doing fstests baseline testing on v6.6-rc5 with kdevops [0] we found that
> the XFS assertion with:
> 
> XFS: Assertion failed: bp->b_flags & XBF_DONE, file: fs/xfs/xfs_trans_buf.c,
> line: 241

Known issue.

https://lore.kernel.org/linux-xfs/20231128153808.GA19360@lst.de/

-Dave.
-- 
Dave Chinner
david@fromorbit.com
