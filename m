Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4FC9530595B
	for <linux-xfs@vger.kernel.org>; Fri,  5 Dec 2025 15:01:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764946910; cv=none; b=u0gDX2Uo9R36FNInEcF0HbN6kJBWPcSLAEPChZUoe0KZW1g9W/LcWwxBKSj94d3JvTxHO+OXVsoPIo8vxl4fDuIPanhsgeRGa96JsaWixFeLCd2a0JRWB84eOINJSssTWIfZKuymYknffsUVoSoHi2VK/2LBkzZoeBIo8Ry8WEs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764946910; c=relaxed/simple;
	bh=W6LYl/ClOgnfGA2SoeKv0w5/4i3UBSi70YUs3pfb788=;
	h=From:Date:To:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=M5hTyY16PRMpG3zbWTCpknJoZyr83pClDUYpK9UAeTnbpHUaTmvbw++Rq6Ki2J3MD5wjablWFi4WAIQGoqM01DA3tnnjqDz/MGCepXRxX66yvaoFzz3kbZORRVdGjcKeh2x55nAqXtWbEdzRTa3fDs7v52ww603iWS/dM/OA+Gk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=SpGDsT/u; dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b=BABWmRak; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="SpGDsT/u";
	dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b="BABWmRak"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1764946901;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=oF37ATwdoYAwLqRZkqLFYSkCSkROHaEUWhLnsJiIeVU=;
	b=SpGDsT/udvzh6IYJ1S9xclxmjUxJm95IWpVWKLnOOCasJIO0dwKF6gGT1cb6jFl7MFbJfn
	kH9Rq08x6chiEgVv0wfQVMGwlLjXltotPoDbbarp6xKe8KDEmJnkidIcCT2EvGxkCNnO9b
	MaQqNyfd+unNQO4MhF76BzP29DsH050=
Received: from mail-wr1-f72.google.com (mail-wr1-f72.google.com
 [209.85.221.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-297-VVHLsn1mPoCNSbsUW6-4QA-1; Fri, 05 Dec 2025 10:01:40 -0500
X-MC-Unique: VVHLsn1mPoCNSbsUW6-4QA-1
X-Mimecast-MFC-AGG-ID: VVHLsn1mPoCNSbsUW6-4QA_1764946898
Received: by mail-wr1-f72.google.com with SMTP id ffacd0b85a97d-42b3086a055so2077770f8f.3
        for <linux-xfs@vger.kernel.org>; Fri, 05 Dec 2025 07:01:39 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=redhat.com; s=google; t=1764946898; x=1765551698; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:to:date:from:from:to:cc:subject:date:message-id:reply-to;
        bh=oF37ATwdoYAwLqRZkqLFYSkCSkROHaEUWhLnsJiIeVU=;
        b=BABWmRakzqzEHoLO9H2LLIEqEyt+YQ4TBdcz/jr3gNDzBQj5av9DyDDBGvjzUynXJu
         4b8NA6XuDdiC2H2aZvHy1rnYiYQbQc0EM6x6BjXDBAExkT2pmDwp2MgqMBZP7hvx3hTO
         0HWTGueJhAmYU87GYB0LLKIg3bnz4UWFX+EkSi5vzEmA3k1SL6G12EjPQQJL8Ad04len
         +l/U7FkJhECFIoKAnluKDWYmAIBQXc+nJcJlSBEnnbP1m7q5t2Z33ujSWoJss09y+9h2
         WSbDcr28dzMtPPJ9JCoP6Qxo05QvXNn2llO86IqqlnS5aize8zNzo80bMhC0iWUfm3pJ
         Tzeg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1764946898; x=1765551698;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:to:date:from:x-gm-gg:x-gm-message-state:from:to:cc:subject
         :date:message-id:reply-to;
        bh=oF37ATwdoYAwLqRZkqLFYSkCSkROHaEUWhLnsJiIeVU=;
        b=kn20C3Nq4SN692v3uThy7VxGxsp0kQD2btRLLdSW65yjVSCZNuQaqHMty3P2Gk/5mv
         NxUl/IZrVol1KQwt046jGJSOOsoK2E8g05Cc2oQiSzc9WgJlkJXvXr0YDTfFKeywAqaR
         gpY6JQlRPhj9KWTJaCkqMy6sAV0wYyJbrBvmXOrzAkvHvc8EbF604YxiArNSRM0mPczF
         fGoTXtDJK5ZK2fQziptnjbOGcoat+m+93GluSvc++57/LSaaq5Bpd1vfFcB9kx/okwhY
         noxc2pKJCJMa3F3DpLlbq5gtAsyi4AwENLWNcia78TkGjut5HhIXYb+R16XKNG/uRqyR
         6omQ==
X-Gm-Message-State: AOJu0YwsL/M/ZXihp9w5+uNRXOERhyR0E9tB1eVotrK9bIA9AOFfdhdu
	qbzFGLSaUnATFE0dPINr5kA+X/ieWOinA4aCxVNE0C1QUbrrg5S2TYKKbL2cft554bt3rL/MmXk
	gUIqk3Q0SxXdLDjBhiY7T1a7jpw7lS6iKfIdYlFJjz2j5TRDP27s4B9bWFrqhCS+jc8+jHgFQs7
	V2F2B2LQMY2EuKeUiAUBJYbfKLhisNz1qPpumP/AByPump
X-Gm-Gg: ASbGncu/sUBOtoOK84h1YjhhaPdB9E1/tSSVrFa0fA1PJndNXc4JNh77M3EiCNU3ruO
	2OsUIYKmA8bgz50pSWNNOL5bmibhoKXVVnCf5ra25A8IZ7gn4wwfyZHvqHo0y75OQ3rbjHUHqg1
	1RHQxE8pLdDD3QZe1WYZ1I78Pvoeg9xVvfPxnBV6EaAATVUp9qfR2xIKetEGU3ksfkLvi3no6+x
	8sMpeV+mdNtI/FsI1pu0eHwAyH0/9tU1wbRQTcM1yAUAW4vbJWR8EKi6QrpYksCTp1IA+KPOQGk
	R2eGj8WU+Ze2BSh0+5KskP+h2hIA57PqrDeCHKsX3v6yFZ+4iNfLXdYuxKsLnfFn6oU1IBszzo8
	=
X-Received: by 2002:a5d:5846:0:b0:42b:3366:632a with SMTP id ffacd0b85a97d-42f79854639mr7900809f8f.39.1764946897605;
        Fri, 05 Dec 2025 07:01:37 -0800 (PST)
X-Google-Smtp-Source: AGHT+IHOq7MwRUFwxhd3azs4mj6I55Tbgx0DKmoWeflEGWEKYH5Ay+Mjdb3kZ2Yr3isR+UWIpp3d7w==
X-Received: by 2002:a5d:5846:0:b0:42b:3366:632a with SMTP id ffacd0b85a97d-42f79854639mr7900721f8f.39.1764946896819;
        Fri, 05 Dec 2025 07:01:36 -0800 (PST)
Received: from thinky ([217.30.74.39])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-42f7cbe8fdcsm9290962f8f.6.2025.12.05.07.01.36
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 05 Dec 2025 07:01:36 -0800 (PST)
From: Andrey Albershteyn <aalbersh@redhat.com>
X-Google-Original-From: Andrey Albershteyn <aalbersh@kernel.org>
Date: Fri, 5 Dec 2025 16:01:35 +0100
To: linux-xfs@vger.kernel.org, aalbersh@kernel.org, cem@kernel.org, 
	cmaiolino@redhat.com, djwong@kernel.org, dlemoal@kernel.org, hans.holmberg@wdc.com, 
	hch@lst.de, preichl@redhat.com
Subject: [PATCH v2 2/33] xfs: remove deprecated sysctl knobs
Message-ID: <puzvf44mor4sfwrjrs3hzwzrqbcatazo5otyjtud4uqqj6aczt@f46eq5wthvdk>
References: <cover.1764946339.patch-series@thinky>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <cover.1764946339.patch-series@thinky>

From: Darrick J. Wong <djwong@kernel.org>

Source kernel commit: 21d59d00221e4ecbcb597eec0021c667477d3335

These sysctl knobs were scheduled for removal in September 2025.  That
time has come, so remove them.

Signed-off-by: "Darrick J. Wong" <djwong@kernel.org>
Reviewed-by: Carlos Maiolino <cmaiolino@redhat.com>
Signed-off-by: Andrey Albershteyn <aalbersh@kernel.org>
---
 libxfs/xfs_inode_util.c | 11 -----------
 1 file changed, 0 insertions(+), 11 deletions(-)

diff --git a/libxfs/xfs_inode_util.c b/libxfs/xfs_inode_util.c
index 2a7988d774..85d4af41d5 100644
--- a/libxfs/xfs_inode_util.c
+++ b/libxfs/xfs_inode_util.c
@@ -296,17 +296,6 @@
 		} else {
 			inode_init_owner(args->idmap, inode, dir, args->mode);
 		}
-
-		/*
-		 * If the group ID of the new file does not match the effective
-		 * group ID or one of the supplementary group IDs, the S_ISGID
-		 * bit is cleared (and only if the irix_sgid_inherit
-		 * compatibility variable is set).
-		 */
-		if (irix_sgid_inherit && (inode->i_mode & S_ISGID) &&
-		    !vfsgid_in_group_p(i_gid_into_vfsgid(args->idmap, inode)))
-			inode->i_mode &= ~S_ISGID;
-
 		ip->i_projid = xfs_get_initial_prid(pip);
 	}
 

-- 
- Andrey

