Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 109A41A0B08
	for <linux-xfs@vger.kernel.org>; Thu, 21 Nov 2024 10:03:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1732183409; cv=none; b=LbFZJgM2ToSB8/+B3Y+ancEx5J0YgXqMtBetPOkgoApAA/3ByGXNLZ1KQdusYDvN29hdeKDSj9roWhuAwl9mYq1PMYAK5tJmSnCDDIFPpWAQP9VRuTAmUH09F7Hr2YqG21wqnr+MnwWx8STKSq3EPEm0z/PbbpK0SCtGkKxfJMg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1732183409; c=relaxed/simple;
	bh=1DikyKK7WvdLlZBgmNsnOJ4Jly6gUydvJnU+pbZw/q0=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=uM2EUkdy6371eLz82V8Eh/Y1lhjHTjxc5eOyYXyK5bGVbJlptcLvvpDc2owOslPuvM1m0hQyWxp4bGl6ad/A/7EpqMuIRLP3wrcHvpczJA+r8f5s2Be/x3Ctgnfkw573f1bBATY6K5NRZjbW1kV6nxlt51qLELGQ6K938iC3Ekc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=Q3hPiKKB; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="Q3hPiKKB"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1732183405;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=CaC/ipvdWYgdC+g1YIvlQTYSbe7hpMUyqF9C7dD/4cE=;
	b=Q3hPiKKBfoFCiaQqsR4PXeA88qJhG6mi5SuuySNMgPItH+IwvbfwQP6VmO8sNBZxM7somE
	Yo6MgV27BCAh3T066zPB4NmdRYGyPw9ez1TCHbVmRKe9+FR5zh4EB2BRbosiLF/iTTsCGq
	eqbqYwTxyJcrz20ikDmM6k9Lc2S4ToQ=
Received: from mail-pl1-f200.google.com (mail-pl1-f200.google.com
 [209.85.214.200]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-261-r8KsM1iMNv-IyRuYu4rJeQ-1; Thu, 21 Nov 2024 05:03:22 -0500
X-MC-Unique: r8KsM1iMNv-IyRuYu4rJeQ-1
X-Mimecast-MFC-AGG-ID: r8KsM1iMNv-IyRuYu4rJeQ
Received: by mail-pl1-f200.google.com with SMTP id d9443c01a7336-20e67b82aa6so7427845ad.0
        for <linux-xfs@vger.kernel.org>; Thu, 21 Nov 2024 02:03:22 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1732183401; x=1732788201;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=CaC/ipvdWYgdC+g1YIvlQTYSbe7hpMUyqF9C7dD/4cE=;
        b=GCkik3qdCbBm3MzlK9el/IgWq1j8S5qLiU/B4bYG+VcWnK0PalgqyhxW1FEYo9kj+t
         CwVSMJuOicz4anrxF396JurizHGmtKPMPewau/JC5CNsjB6AS0heVly6jjAGGgQW9uuU
         T8WM05i53UhLUr3uIVCxe8nKBM44yH6eBznUdmYvpZsmTpbaI3Lo5x52Z4ILY6oLNg7k
         2ThMMtop9kpcWzMc8gcBJLhstU6AQI1aOj5r05sxZeGJ99NvDDXD9fyCpxPe/TYXKNxh
         bWX7r0PI9KXhAsmfIuf4jODNmNohaI8cQW/bqGiOQ01xT4VbxFsrLxkc1GHaZz0+UEj/
         bohA==
X-Forwarded-Encrypted: i=1; AJvYcCXSLXqMa8W2vZ1z7T090LfvzWfdgG1kUlcOn2grpc8IFRdbp4h3BswUZ7IprduxyhZfgNLDOLaMIes=@vger.kernel.org
X-Gm-Message-State: AOJu0Yyzyul+WemewyoQfFPvuUpU5LOmy1BAB7evA9V7ThTcyG1b3QSl
	ATucmX07TN5oVKywtGr6Y54NLwzrW6VNCJG2cx3OalOfMA+JN/JE+DjfQhfgMsFIcSTsY5VCpLD
	9Kfxy1+FCpYrwFyqY1QpjSJAHvzG8YYnvfsld9mzfTFH6YXUeF3EK3WFvOJOgAanAwfpu
X-Received: by 2002:a17:902:f551:b0:20c:aa41:9968 with SMTP id d9443c01a7336-2126a49ddfemr83444585ad.53.1732183401494;
        Thu, 21 Nov 2024 02:03:21 -0800 (PST)
X-Google-Smtp-Source: AGHT+IGiFOED9gXnf0cEhe7CQvRNF+jWARUlG9zyCyXXLBg46ifFj38fBdUHadvrECr+GhtCqpiWUA==
X-Received: by 2002:a17:902:f551:b0:20c:aa41:9968 with SMTP id d9443c01a7336-2126a49ddfemr83444225ad.53.1732183401112;
        Thu, 21 Nov 2024 02:03:21 -0800 (PST)
Received: from dell-per750-06-vm-08.rhts.eng.pek2.redhat.com ([43.228.180.230])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-212883fde4asm9993755ad.259.2024.11.21.02.03.19
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 21 Nov 2024 02:03:20 -0800 (PST)
Date: Thu, 21 Nov 2024 18:03:17 +0800
From: Zorro Lang <zlang@redhat.com>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: zlang@kernel.org, linux-xfs@vger.kernel.org, fstests@vger.kernel.org
Subject: Re: [PATCH 11/12] xfs/157: do not drop necessary mkfs options
Message-ID: <20241121100317.zqz6l4z7kawqxtia@dell-per750-06-vm-08.rhts.eng.pek2.redhat.com>
References: <173197064408.904310.6784273927814845381.stgit@frogsfrogsfrogs>
 <173197064593.904310.9005954163451030743.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <173197064593.904310.9005954163451030743.stgit@frogsfrogsfrogs>

On Mon, Nov 18, 2024 at 03:04:15PM -0800, Darrick J. Wong wrote:
> From: Zorro Lang <zlang@kernel.org>
> 
> To give the test option "-L oldlabel" to _scratch_mkfs_sized, xfs/157
> does:
> 
>   MKFS_OPTIONS="-L oldlabel $MKFS_OPTIONS" _scratch_mkfs_sized $fs_size
> 
> but the _scratch_mkfs_sized trys to keep the $fs_size, when mkfs
> fails with incompatible $MKFS_OPTIONS options, likes this:
> 
>   ** mkfs failed with extra mkfs options added to "-L oldlabel -m rmapbt=1" by test 157 **
>   ** attempting to mkfs using only test 157 options: -d size=524288000 -b size=4096 **
> 
> but the "-L oldlabel" is necessary, we shouldn't drop it. To avoid
> that, we give the "-L oldlabel" to _scratch_mkfs_sized through
> function parameters, not through global MKFS_OPTIONS.
> 
> Signed-off-by: Zorro Lang <zlang@kernel.org>
> Reviewed-by: "Darrick J. Wong" <djwong@kernel.org>
> [djwong: fix more string quoting issues]
> Signed-off-by: "Darrick J. Wong" <djwong@kernel.org>
> ---

Oh, you helped to merge the patchset at here. Thanks :)

>  tests/xfs/157 |    3 +--
>  1 file changed, 1 insertion(+), 2 deletions(-)
> 
> 
> diff --git a/tests/xfs/157 b/tests/xfs/157
> index 9b5badbaeb3c76..e102a5a10abe4b 100755
> --- a/tests/xfs/157
> +++ b/tests/xfs/157
> @@ -66,8 +66,7 @@ scenario() {
>  }
>  
>  check_label() {
> -	MKFS_OPTIONS="-L oldlabel $MKFS_OPTIONS" _scratch_mkfs_sized $fs_size \
> -		>> $seqres.full
> +	_scratch_mkfs_sized "$fs_size" "" -L oldlabel >> $seqres.full 2>&1
>  	_scratch_xfs_db -c label
>  	_scratch_xfs_admin -L newlabel "$@" >> $seqres.full
>  	_scratch_xfs_db -c label
> 

