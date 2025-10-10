Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 65797277037
	for <linux-xfs@vger.kernel.org>; Fri, 10 Oct 2025 10:05:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760090710; cv=none; b=q4FZnL0NMs19cP03YW78IWrNySDkqGfs/oXwAf+JkrhGjMoh6bxQwMsMlqjrfEh+5ndxDcS9pkM68yU8IK28zecCkNyhfgvpLcNZMXkuQixlqClJmIH4pvTbx2ZaRGLRiMqYFY3RMLYYeVv8FlcUZbmnxb84tz7vkFl7buPO9qk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760090710; c=relaxed/simple;
	bh=yxjUvtTYbJzNPd6jcvWn4XkfkMtZPuAQxmu/eENPV1k=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=VMhVF48ZHBv8Z2vD6inCfuexJNKw0kuQYqyx/0d2hRiGDa/pBBEwliYZiV49lxhJhwP7UQmGwejj7tMzVWHDYMlrDG7+wpOk2M2elaDEPR4X7BhwwLa/f3Ju8o9w7qQsvQT6Ji97qTWTsovUBgaWCABqOQi0UqYVrN8aC07bAtE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=UVwQB8Jm; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="UVwQB8Jm"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1760090708;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=1tnuXFIEOnkdTLEedmD2VLZtLJP/FDB86U+RErd2EzU=;
	b=UVwQB8JmsifIDwDTwbpf/vN59yRqHQrCXnyMqTkNpkJew7aytDyk1KkKjqIwsUO/ZFmx43
	MWYZdytSW/zzmcJutHoVfYbkJaz65a0ZaCYAJ58g/kKrcSfRr4LNq87ekUdQMu3tIWI1B0
	Mo/pQUi6zODDB+suHnf4s80PDab+Q8g=
Received: from mail-wr1-f71.google.com (mail-wr1-f71.google.com
 [209.85.221.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-649-usTIxCYrO4mfCf348zkSEg-1; Fri, 10 Oct 2025 06:05:07 -0400
X-MC-Unique: usTIxCYrO4mfCf348zkSEg-1
X-Mimecast-MFC-AGG-ID: usTIxCYrO4mfCf348zkSEg_1760090706
Received: by mail-wr1-f71.google.com with SMTP id ffacd0b85a97d-3ef9218daf5so1742845f8f.1
        for <linux-xfs@vger.kernel.org>; Fri, 10 Oct 2025 03:05:07 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1760090706; x=1760695506;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=1tnuXFIEOnkdTLEedmD2VLZtLJP/FDB86U+RErd2EzU=;
        b=PCG6WczEE6wcw2KULeu6cmi0AOaUSij75i35/0TbxfnM2KDVBTe1VubQZwOQJCBDOZ
         h97mccZFeUw48ucxz4dp5w3n8KREUNp0UG4oC8Wn+B08C8jeg22yK0TEglgQZ7rRpuqj
         4y4Jku2/5h0uCfqXMFKSTq3lQ+ZtJbTWr28rVZqdwdmS5BN/KV0AxcDdeV7Bes4bWxV2
         3/tvcLe1F82Xcvx0u+qWyIXiMzFUu06j0Y4vyX/Cg/4Vz44Ss+DEY3Dg4vFoeZJYSDL5
         GN7Cb0em2QBBAhWcfkThlIoRbZ54Uva1pALC1ta5lxiA04z7sXcIiGt3sBx45MJeyLB1
         gIaA==
X-Forwarded-Encrypted: i=1; AJvYcCU41+X4qgtdeK2E0O5CBaZpveNHkJNHE31J0OWPxf6XDU81jEdge1wsGhUH9VjPHBBRQwxlFzKEj7I=@vger.kernel.org
X-Gm-Message-State: AOJu0YxURCCwIqpb6jRazFokDFqgbRdBwX8l1kQR4/3slIwLp9sIQBiz
	Bm6U2y60oAgOiUbFCUvyLB+FwwvEBOTpNlero7LmbFp2RmucVwny3oSsDY3CYK89eKYP5WHn1Zq
	EHC4sOYlQr9g3wiF4fI+jYtWQwIolvz8cFzOBMy5RbJbVop9N0cvKE4VdGVnh
X-Gm-Gg: ASbGncvl+rtjJE9Qael10kjy56xK1j/eWgYr946nZzO1wPSn/MpCMyEs4Ifh2eWiy26
	BcpjdKvZFmstkNBWlsk53iY6Z9bCPJkQo86MnaTMgUx0Kz/HPhqyyV0B3REod5auOIU0f1uGAJq
	qGjye2DrXXragutCKoWjxVBvYo3wit0LpBYXQqJrkU2fjiYOyaEYfw6uuTcv9C8qEhV5WUYtWgc
	UDztIQRK8DwfxgVKb5x3MIravjBLbDC05pVGPcrdfB/tQVoLCO7FdUrIr48SsOQ3y1nzql9GLmX
	08dZn21VjngIe4TctJkL4m/sOrT2vBF+E/PiiNHODq7DicMAGI8mmtS+i6iZ
X-Received: by 2002:a5d:5f82:0:b0:405:9e2a:8535 with SMTP id ffacd0b85a97d-4266e7c0240mr7991706f8f.27.1760090705837;
        Fri, 10 Oct 2025 03:05:05 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IF3MG+EMhV6WcoQA4r+co7LNvaX9gw5/qrhvPUQ1CI9icTl+BzkJJl0HQutbbiXtsdES2s0pA==
X-Received: by 2002:a5d:5f82:0:b0:405:9e2a:8535 with SMTP id ffacd0b85a97d-4266e7c0240mr7991667f8f.27.1760090705321;
        Fri, 10 Oct 2025 03:05:05 -0700 (PDT)
Received: from thinky (ip-217-030-074-039.aim-net.cz. [217.30.74.39])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-426ce583664sm3470012f8f.22.2025.10.10.03.05.04
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 10 Oct 2025 03:05:04 -0700 (PDT)
Date: Fri, 10 Oct 2025 12:05:04 +0200
From: Andrey Albershteyn <aalbersh@redhat.com>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: linux-api@vger.kernel.org, linux-fsdevel@vger.kernel.org, 
	linux-kernel@vger.kernel.org, linux-xfs@vger.kernel.org, Jan Kara <jack@suse.cz>, 
	Jiri Slaby <jirislaby@kernel.org>, Christian Brauner <brauner@kernel.org>, 
	Arnd Bergmann <arnd@arndb.de>, Andrey Albershteyn <aalbersh@kernel.org>
Subject: Re: [PATCH 2/2] fs: return EOPNOTSUPP from file_setattr/file_getattr
 syscalls
Message-ID: <q6phvrrl2fumjwwd66d5glauch76uca4rr5pkvl2dwaxzx62bm@sjcixwa7r6r5>
References: <20251008-eopnosupp-fix-v1-0-5990de009c9f@kernel.org>
 <20251008-eopnosupp-fix-v1-2-5990de009c9f@kernel.org>
 <20251009172041.GA6174@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20251009172041.GA6174@frogsfrogsfrogs>

On 2025-10-09 10:20:41, Darrick J. Wong wrote:
> On Wed, Oct 08, 2025 at 02:44:18PM +0200, Andrey Albershteyn wrote:
> > These syscalls call to vfs_fileattr_get/set functions which return
> > ENOIOCTLCMD if filesystem doesn't support setting file attribute on an
> > inode. For syscalls EOPNOTSUPP would be more appropriate return error.
> > 
> > Signed-off-by: Andrey Albershteyn <aalbersh@kernel.org>
> > ---
> >  fs/file_attr.c | 4 ++++
> >  1 file changed, 4 insertions(+)
> > 
> > diff --git a/fs/file_attr.c b/fs/file_attr.c
> > index 460b2dd21a85..5e3e2aba97b5 100644
> > --- a/fs/file_attr.c
> > +++ b/fs/file_attr.c
> > @@ -416,6 +416,8 @@ SYSCALL_DEFINE5(file_getattr, int, dfd, const char __user *, filename,
> >  	}
> >  
> >  	error = vfs_fileattr_get(filepath.dentry, &fa);
> > +	if (error == -ENOIOCTLCMD)
> 
> Hrm.  Back in 6.17, XFS would return ENOTTY if you called ->fileattr_get
> on a special file:
> 
> int
> xfs_fileattr_get(
> 	struct dentry		*dentry,
> 	struct file_kattr	*fa)
> {
> 	struct xfs_inode	*ip = XFS_I(d_inode(dentry));
> 
> 	if (d_is_special(dentry))
> 		return -ENOTTY;
> 	...
> }
> 
> Given that there are other fileattr_[gs]et implementations out there
> that might return ENOTTY (e.g. fuse servers and other externally
> maintained filesystems), I think both syscall functions need to check
> for that as well:
> 
> 	if (error == -ENOIOCTLCMD || error == -ENOTTY)
> 		return -EOPNOTSUPP;

Make sense (looks like ubifs, jfs and gfs2 also return ENOTTY for
special files), I haven't found ENOTTY being used for anything else
there

-- 
- Andrey

