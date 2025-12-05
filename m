Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A6BEB32D0C0
	for <linux-xfs@vger.kernel.org>; Fri,  5 Dec 2025 15:02:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764946977; cv=none; b=DXWBnMNdqhypP+onyemd9c0bnG9sty8ovZKZbF8IbS0+S7qDGrkV/ee8jL/Awo7qLunxc5DpZuHSQOADWtoyY8AlYp4W92PiAeaSy+DstAcyTtM+c7abSFH9lip/ezzoAJYqlWiy+mS31ftRxr+dzHvIbNqY+5JvTBtXNtmDI6o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764946977; c=relaxed/simple;
	bh=fUmZS57XiZXtxrqbzJIbKW5XdJHlZTD7Q9UJlDvVqOY=;
	h=From:Date:To:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=hQ9IgVxhOXeyg8YGue4oMPKj7mDLSch6F76oEKrwM58LhsosuQs78ICDugrt3EMKb0mRIAt14O4763X6YwHHFiRukhQLG2Rx2zEVGp141xVVhshMGoIvvS0h5WJfFO37yTy/zmSudmaTEtaw/UhMrxx8yI2738lk91d4Z+ENFUk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=HrODalbg; dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b=OldoK+OB; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="HrODalbg";
	dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b="OldoK+OB"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1764946972;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=wUx1UYoi2OkkiqI05TUTxZhizMlqWbWg3c7YqF4njvo=;
	b=HrODalbg04u1Q76nGeazIFnUbks4mdjhFwpTYmUQZCMNauHrZFEEX5cuAVlsFpmblI3U3D
	yd4AAVeNYQctCpQzlnU1hD2cNhxBi1JWtMm9UCs0WWM4Iv20aTq13Vl3ydCJzBQMt9jFAG
	+w5F9ANBGSHw7raMucKqZmy/CmnTwn0=
Received: from mail-wr1-f70.google.com (mail-wr1-f70.google.com
 [209.85.221.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-365-o61MJhKTOOygMF58lWgdag-1; Fri, 05 Dec 2025 10:02:50 -0500
X-MC-Unique: o61MJhKTOOygMF58lWgdag-1
X-Mimecast-MFC-AGG-ID: o61MJhKTOOygMF58lWgdag_1764946969
Received: by mail-wr1-f70.google.com with SMTP id ffacd0b85a97d-42b570776a3so1108386f8f.3
        for <linux-xfs@vger.kernel.org>; Fri, 05 Dec 2025 07:02:50 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=redhat.com; s=google; t=1764946969; x=1765551769; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:to:date:from:from:to:cc:subject:date:message-id:reply-to;
        bh=wUx1UYoi2OkkiqI05TUTxZhizMlqWbWg3c7YqF4njvo=;
        b=OldoK+OBbjbbD5juqOs1W0xhYwECX6iOJxBM3eaojcvnO5BT1UYBc0ACOUF4nON1Ad
         dd8/apLrb+y1V5XecGQZ/JG8mC5NnLy8sBKCqRc6xsBf/Re/9QTiZ+gC5H6oNyBS3+4E
         dAwn7I8kLhg646SRXgU7E3spfp2vx26eLz8myc3NNHMuCBlI2LIPnsPC3TT6vEveLwn8
         JW5rijzNQN7PpYadAsGmxv7AkEBjAtDZr92qR7XSlmJ0+Lh2hXPC1jILRTvrWyUk3xHN
         mbq+On+gYS6buAyeO2WkpD2MfV0gayCw/H1b6TAgIidnwRcNbKB1aPsy7bC4IrEJnh8I
         ARVQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1764946969; x=1765551769;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:to:date:from:x-gm-gg:x-gm-message-state:from:to:cc:subject
         :date:message-id:reply-to;
        bh=wUx1UYoi2OkkiqI05TUTxZhizMlqWbWg3c7YqF4njvo=;
        b=VQU4G8sIpcVQuLVggVe0SvACbtXPcjjyheDrnH/BasPtWZCb7yeQpRMsB3j7+/QR2Q
         D+fN0fIJTNt7hGZMnRDLWsRYlLjPLBzCrkaaaiM1TzBBBbR3cy9Q8SVLU/m6/VQ5iCI0
         5SZs3eglJ3W9KQsJE/VDeglexycNZvu16CI3v87JoLiy+BK9+rGfzuBVmW4Zkq75VLGW
         Ol1421I4WExOqab3IvdqID79bBuJSbUkCX9I+0h4jQoixCGwy5UwzFPD7jMMlKbqMrDP
         ou+CN6zutfRDzi9r7BqUEx4rKfNO4MaxgYfOEKXVbbAjDAngkgrlpz2w6wC+DJc3b3GW
         72zQ==
X-Gm-Message-State: AOJu0YzGeEhPisP2md89JEUfuLJczEpAI/U+neq/DQgnqBtlJxcFHOEG
	0XzAWLE5qJvCwh2fcT3J2nvYmK/+ibALtHkwMrK0HANJuuVKukihZRO5IH6LsOr9uTjzEVef3H7
	fshpbCVltJ0yu67nkx/IQUb9dssSWUsQAjOFBdifGMU56tPUX1oy7HR6LQNZmXQ+lIFyLNCkry7
	+O/+yTnMOjUxFsy0ooeHVy+e6Z/9Bo6LLiFfF2R+av5B+A
X-Gm-Gg: ASbGncvZ/SJUhTWjh7cECA6TP4bl3rmLsvKOSGQlT0Hv5uae3+OdB2cNixwO1QW/dZK
	r1UlJaqudlKcZVnMSLMZ1IlYRgBhegXKdHs8yNlvb/G/gY4yvVgjC1Dmda1y7vkoOgJmuCr7DON
	tuJX49nzGGkV9XfbaLFILVCl525sw2QOnCKO67ZZ0qkFb+ykeAutjaFpsc7rs3uF0ghOPbrwkSz
	YRBRdOkCR8uriZLQ2HWn6/4hnJnCs63jLjj8ra2IgsHazqSvnshKwCs9nWNpUxkiMnrnVkSTl0h
	NBkU64tdElgQDquPNuQBQBkpUaoxNBQmYr/4wJAc6xb0GWN3IWFh/KO+k3LT/rS1q2tYg+lyR/M
	=
X-Received: by 2002:a5d:494b:0:b0:42f:8816:a50a with SMTP id ffacd0b85a97d-42f8816a549mr426687f8f.63.1764946968670;
        Fri, 05 Dec 2025 07:02:48 -0800 (PST)
X-Google-Smtp-Source: AGHT+IGz8YUXziIcdcJGxd2yY6oVO/ftyrhjjEkjiOEX9tg2NmuuuTDn26PnHMgfYLYK8uJpcAleJw==
X-Received: by 2002:a5d:494b:0:b0:42f:8816:a50a with SMTP id ffacd0b85a97d-42f8816a549mr426605f8f.63.1764946967882;
        Fri, 05 Dec 2025 07:02:47 -0800 (PST)
Received: from thinky ([217.30.74.39])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-42f7cbfee50sm9270200f8f.14.2025.12.05.07.02.47
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 05 Dec 2025 07:02:47 -0800 (PST)
From: Andrey Albershteyn <aalbersh@redhat.com>
X-Google-Original-From: Andrey Albershteyn <aalbersh@kernel.org>
Date: Fri, 5 Dec 2025 16:02:46 +0100
To: linux-xfs@vger.kernel.org, aalbersh@kernel.org, cem@kernel.org, 
	cmaiolino@redhat.com, djwong@kernel.org, dlemoal@kernel.org, hans.holmberg@wdc.com, 
	hch@lst.de, preichl@redhat.com
Subject: [PATCH v2 15/33] xfs: remove the xfs_trans_header_t typedef
Message-ID: <33b3bvlg67nntatmrlnvjok37n5oonyb7hfzyfihgavdzoy7vy@i36h4rpeznkj>
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

From: Christoph Hellwig <hch@lst.de>

Source kernel commit: 05f17dcbfd5dbe309af310508d8830ac4e0c5d4c

There are almost no users of the typedef left, kill it and switch the
remaining users to use the underlying struct.

Signed-off-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Darrick J. Wong <djwong@kernel.org>
Signed-off-by: Carlos Maiolino <cem@kernel.org>
Signed-off-by: Andrey Albershteyn <aalbersh@kernel.org>
---
 libxfs/xfs_log_format.h  | 4 ++--
 libxfs/xfs_log_recover.h | 2 +-
 2 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/libxfs/xfs_log_format.h b/libxfs/xfs_log_format.h
index 367dfdece9..2c3c5e67f7 100644
--- a/libxfs/xfs_log_format.h
+++ b/libxfs/xfs_log_format.h
@@ -212,12 +212,12 @@
  * Do not change the below structure without redoing the code in
  * xlog_recover_add_to_trans() and xlog_recover_add_to_cont_trans().
  */
-typedef struct xfs_trans_header {
+struct xfs_trans_header {
 	uint		th_magic;		/* magic number */
 	uint		th_type;		/* transaction type */
 	int32_t		th_tid;			/* transaction id (unused) */
 	uint		th_num_items;		/* num items logged by trans */
-} xfs_trans_header_t;
+};
 
 #define	XFS_TRANS_HEADER_MAGIC	0x5452414e	/* TRAN */
 
diff --git a/libxfs/xfs_log_recover.h b/libxfs/xfs_log_recover.h
index 95de230950..9e712e6236 100644
--- a/libxfs/xfs_log_recover.h
+++ b/libxfs/xfs_log_recover.h
@@ -111,7 +111,7 @@
 struct xlog_recover {
 	struct hlist_node	r_list;
 	xlog_tid_t		r_log_tid;	/* log's transaction id */
-	xfs_trans_header_t	r_theader;	/* trans header for partial */
+	struct xfs_trans_header	r_theader;	/* trans header for partial */
 	int			r_state;	/* not needed */
 	xfs_lsn_t		r_lsn;		/* xact lsn */
 	struct list_head	r_itemq;	/* q for items */

-- 
- Andrey

