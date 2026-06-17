Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 944D43D9024
	for <linux-xfs@vger.kernel.org>; Wed, 17 Jun 2026 10:21:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781691676; cv=none; b=I5PO/hcahrVsfLilwzltJCId+KZP/y2sbzuAPwbpe0z39tcDhhrK84Ngo8A28OAtWY58udQuhCVRzYOGMfEU4sQ/DfkDGk4LUZPO1DPb2qypkLKYV7WmiX37+BRnfaqwz+lRw0UO2n3Pw12nZ1ezKAz8o1f9kDBiCqwYcho8G2s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781691676; c=relaxed/simple;
	bh=iFjHXCOkHms8733u2YS89Y4W983Y10t3ytnSjC7f+SQ=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=FbV7olKd5tmC/vBZv7qf/CldyD+x6J7dpsard2Umk2GZZxs2xKNfpQQot6hfXaqpGp84b0aiCrcm+i21BkxyVej71yeGAhF0FjHtUHzIfj9QojaAB1OaArkmnWJ4sa7v+pGsGUV6RYlu7Sk5rOqmWZQPefwEj/3xK6FIb27zJo4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=UNabP+jf; dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b=Sd3jVxn7; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="UNabP+jf";
	dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b="Sd3jVxn7"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1781691668;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=JFPjjdZ2csUsNrDKtk2Mr8R6p8O/uPdh2r9FCPzwJMY=;
	b=UNabP+jf7SBMB38KnvPdnTbYbuOH9EgX0jsznBp/f83OrOdxmUEFth0d+4ojUo17BcpkKB
	VZWADMugt4aMPkSzRlFnacHEUBCJENVdaq5PISukSDAKyubY7IKNuVTpRtk3DvYrzKHHMn
	WG0qnLZBMAFCme3gyHnTbFXlAG0wjSE=
Received: from mail-wm1-f72.google.com (mail-wm1-f72.google.com
 [209.85.128.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-348-LTB2C8ukN5OoZvKCUZEsUA-1; Wed, 17 Jun 2026 06:21:06 -0400
X-MC-Unique: LTB2C8ukN5OoZvKCUZEsUA-1
X-Mimecast-MFC-AGG-ID: LTB2C8ukN5OoZvKCUZEsUA_1781691665
Received: by mail-wm1-f72.google.com with SMTP id 5b1f17b1804b1-490ae461f8dso42502325e9.1
        for <linux-xfs@vger.kernel.org>; Wed, 17 Jun 2026 03:21:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=redhat.com; s=google; t=1781691665; x=1782296465; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=JFPjjdZ2csUsNrDKtk2Mr8R6p8O/uPdh2r9FCPzwJMY=;
        b=Sd3jVxn7rzurCsnKJidOK4xFz2SpM4D4CAL1lVaRturZPjVGPyRK84SU1lpVvv5UFf
         UDBxBGBXc+eyUBH60xFO6BAD0IoNDcP3fAoPsKtSlz54BWkOUfofXLjep82UjgLG/Bs4
         FH73lghYB2IZBI4TAkiy+H2C1P/FlKWQ8FL2B8NtHHC7MBDhO8ZurL1Tigd5Y9+Jjo4t
         kAcrilwQwSPnc5BpZTsy8O+RG8LT6Ba5nk7T454gZMruecfK9mcXPTF9ZvYjtyp0FS8r
         URWZTEig8b3bV5/EYSQeM/tWs+JkE4E/XqCDbsWWRF1TN3yMbQSxoIJIk6gVS7xiH2os
         5hnA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1781691665; x=1782296465;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=JFPjjdZ2csUsNrDKtk2Mr8R6p8O/uPdh2r9FCPzwJMY=;
        b=FjthPQjBRJde/RMWxZf0YvJDJjkrJya6PVlfEqh7GJNodWwx6cGK+gH4xJz5su/vqq
         RHjen7aHBACZN+5BMEdYaWr3ATQk00Jm4Tq081DsmJnFuLK1EOXos/54xwNCi+lxMuDo
         SZj1WtgpCrZM7l5NJzC2uL1irtTFWd4GF1G2CVS2AhD9REKNzuVL4LLDl9eQgBxS/0/k
         rIT1nv+f4XgO4FzPR5uRhOEkoysWF0qQRISgpbbd0ienbK5GqNRoMZafQEm9W0evBMCA
         kFvOjGVNcQR5CPh/dmrEplexdbOGd5HAvXAn80vmWr+Dh7DAnUUOSM8Po+bxJc3qn4Xn
         MigQ==
X-Forwarded-Encrypted: i=1; AFNElJ9ovfLf5neIT4+C4zeogZdc2rxQFjWpkc2zb6C81jvFTkNN1GjB/BepDqSSVWskyzsebnJDroBck+s=@vger.kernel.org
X-Gm-Message-State: AOJu0YyPG2IWxPvWYTgyS4C3kLjujxpMFD0rBLEVf/7CQOQDtjsi5BJ7
	xJjG779g7M1KetU0gaMlJjNBAQGTZ2Uxr9xX9AlTq0+R14c1FBh8HQ1/Ozzcle/kY7d71+RQfK7
	oc800sB9/e0kjiJA7dV05F44VdwYnqG+JcNAsqVfaOslDAya9KUAj5RHfRfv5dZsJV7jP
X-Gm-Gg: Acq92OG5c+xJ1lOUfhSTJfuY4EUhX6/UQmFodhO0dw7gXUh9QQZlnpjTbWudF4A+24w
	L/hAxm070sA+nMjDKwvdXMguanF2uldw05x7I8M76ZfON3BPw3wUDUcdhman5ea6kA1cYi6BHB4
	/lc6HNIf7qI1aqrQPYSJg6LwUT4T+rQJxaj4wCehp7qj/J9iNmje6kx3oF+BbiNAAHbuDQ0Oxrt
	l5g98TBay/XsmKOPp3QSdFP6bbOsWlQanyqYMp70tR6SFObgX5MyPqbUk2V69vxPgCP7JM8S/vM
	+mlJkDh7AoV5nplL6j0rcefHmlX8gWIRcCicQ6vSsAwDp8w0fKmfHkx8TnxKoWgnIHb/t+7FayM
	NCDLRTeeZHh1vDnGL2o6i3rS9Gu+4nydduRNbqvnXxi17zQ==
X-Received: by 2002:a05:600c:828c:b0:490:be14:bfda with SMTP id 5b1f17b1804b1-4923339fd76mr58254055e9.6.1781691665421;
        Wed, 17 Jun 2026 03:21:05 -0700 (PDT)
X-Received: by 2002:a05:600c:828c:b0:490:be14:bfda with SMTP id 5b1f17b1804b1-4923339fd76mr58253275e9.6.1781691664833;
        Wed, 17 Jun 2026 03:21:04 -0700 (PDT)
Received: from aalbersh-thinkpadx1carbongen13.rmtcz.csb ([217.30.74.39])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4922fa891acsm152291985e9.9.2026.06.17.03.21.04
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 17 Jun 2026 03:21:04 -0700 (PDT)
Date: Wed, 17 Jun 2026 12:21:02 +0200
From: Andrey Albershteyn <aalbersh@redhat.com>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: aalbersh@kernel.org, linux-xfs@vger.kernel.org, hch@lst.de
Subject: Re: [PATCH 6/6] xfs_healer: allow AF_UNIX socket access for
 xfs_healer instances
Message-ID: <ajJ0pQ96_aeJ5hhr@aalbersh-thinkpadx1carbongen13.rmtcz.csb>
References: <178118661216.728615.4369200471498381381.stgit@frogsfrogsfrogs>
 <178118661353.728615.8408589793793380068.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <178118661353.728615.8408589793793380068.stgit@frogsfrogsfrogs>

On 2026-06-11 07:06:23, Darrick J. Wong wrote:
> From: Darrick J. Wong <djwong@kernel.org>
> 
> When xfs_healer cannot fix a filesystem problem on its own,
> run_full_repair function tries to start an xfs_scrub service instance to
> scan the entire filesystem.  Unfortunately, as Codex points out, the
> service definition for xfs_healer instances doesn't allow AF_UNIX
> sockets, so that will fail.  Relax the security posture so that we can
> do that.
> 
> Cc: <linux-xfs@vger.kernel.org> # v7.0.0
> Fixes: 88825fe0de0df2 ("xfs_healer: create a per-mount background monitoring service")
> Signed-off-by: "Darrick J. Wong" <djwong@kernel.org>

Oh, it's systemctl<->systemd who need AF_UNIX socket, couldn't find
where xfs_healer uses sockets :)

Looks good to me
Reviewed-by: Andrey Albershteyn <aalbersh@kernel.org>

-- 
- Andrey

