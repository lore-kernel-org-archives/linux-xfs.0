Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.221.54
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795306154;
	b=0ImFfQNz1qv+cT1cMDOGONdqAaH2Ff5viva5cjOa3Xj0td7k1n7+4UITeNjk98YO5sOy
	 gqf89iCvDbatKCt2jvoDfbHXARbNevhQU1hXg59c3tNbCEwKmotF6/M+89hJ8OErZIYZH
	 Rki5IcmFU0F64uGCv6CtWDLpdqC1D7HC/kjV5QXIyXXFCoOUVo3jn3JkToBaeVFL2lc2v
	 +vLxu4PxcvPjC8y4aqcDDb9Uzf/u/9EShRdlaZIQEbmswZRoTWr0N5LKyO1utiqK4k7PP
	 yODkxLdWxzGTOV1xNXIJOSTXPk+WkbtUihTmqz44yThsPnSGIdJvm5KLG80cKvgU/VQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795306154;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 From:To:Cc:Subject:Date:Message-ID:X-Mailer:MIME-Version:
	 Content-Transfer-Encoding;
	bh=m+aU85cIm+C4zcua0cgiJZNThrvCIO+uOHsPRDd+6Js=;
	b=QdGzCdwqAWRakRJnjjACs2CDzGlqCnm4SgcR7hsluYzjUMjGYSywv1zsshlKCUflqJNu
	 CwaEnKHRceqetS7lRndstfIaZvKmAf5KMf1tXDC9TjSYgJGBKHLZsBnb0bZd50CsXo/r4
	 NuswoFdc1qIOOtvA63hn/xlFbZHGlZ6eKyMz6BT5cQ4kSztOeMsbn5ty1Mm4hAkHocrcH
	 pnOlZ4KoZWlDD81TdPyWtDpmakrelYiMrxTqI7/hvuGo4/qYWYqu0y/x6BufBqg5lK5Mg
	 oZNVGuMlcHvUFXEjzkf/3/wDqvWai4zFLNIc6F2CZTxLzX8QLQ7SmV2K+Qf9BsujCjg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=uPs1eFKA;
	arc=none smtp.remote-ip=209.85.221.54
Received: from mail-wr1-f54.google.com (mail-wr1-f54.google.com [209.85.221.54])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2A54B606A332
	for <linux-xfs@vger.kernel.org>; Sun, 22 Nov 2026 00:09:14 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 2A54B606A332
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=uPs1eFKA
Received: by mail-wr1-f54.google.com with SMTP id ffacd0b85a97d-4acb44dcd7bso1527122f8f.0
        for <linux-xfs@vger.kernel.org>; Sat, 21 Nov 2026 16:09:13 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1795306152; x=1795910952; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=m+aU85cIm+C4zcua0cgiJZNThrvCIO+uOHsPRDd+6Js=;
        b=uPs1eFKARZ3CMN/dT8oiRSxugGoFsYDdKXUnYIxGeix5KMAnxe4Q/d3FUpwvXWQNDW
         o3jCvaS8IC75goOsIwb2FpTZGzUiWy+pD/MtACLf4+8QxBVD1zUb/CcM10TR+oe7hIC9
         ju7ZcTGtcQjR3mityRZLNrZ/e9JBOUbyO3B5/RTwvvo9luBkMORWvPlVla22R7BogrFZ
         HP9hMHhopm0Wdj5qdfeTfiAo6V158aCiuK7tgveO6P9LdGfRfXXr6qiA6kvyFiQQ6kN6
         rFHku0ETJBqZYY8cG6bhmTTz4YY9ztpesuz0kc57HvDPn26dQ8CY/N7rAhgU5MWJTDT4
         9x0A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1795306152; x=1795910952;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=m+aU85cIm+C4zcua0cgiJZNThrvCIO+uOHsPRDd+6Js=;
        b=mC9s6cpLFODCxFrNnVvYx5dizHwX4CSwmzt7fn20Hf9S40E4HiVdV/WL15lZucmYj4
         OWQAUd0n/6wVPcgh5UyOzuy1qYw39FLHHfCvTvN/nNyGnRhlVThgdbD2w/nJkG0Ldw+G
         leXHqSXQWwQ4dsuKEkuvzKXi1u61SPnXnGHz/BFhe4pWyTb8AhjkyaW02Mu16Lbo5ynN
         f4yh2AhCoHTiHGcN5KYi1NqdeG8TBUtVmAN29mqCLynC+R+e9L00RUCbi/MFGim79Z3F
         qpjrGWxko+kQNaD1Hak828anhEdkU47Qx1FkTf3fs5hr9gpnBABkQ5UEi62erxL53kUP
         AbHg==
X-Forwarded-Encrypted: i=1; AL+hErFxg2q4mW70+wPWkqYf/WmGorbDZYmmIhdq77iD/RMdwkfZJ818bxupGxF/6YnAHUeFnve4Cr7orGg=@vger.kernel.org
X-Gm-Message-State: APuU4Z+iCBxmGvROdNy+JZCRNyZDMm8mc6o5Z31zgkXP59dpFFUOgbgG
	Kqi18hR5xhtzNEn/RSzv8/kwwCFzs5wtWgZQdEPOQ66wQqPC0hmHZApj
X-Gm-Gg: AZFdTZfclGn8MsJrUc21NbcKJa30RcxdmkFW8z34mqc9FAscTONqw9tmDayEkvTZ5fH
	B9UP7volTdzp4waKxkdjbira9QBX+DvMNkZlLOBn6fYrDNxBHAExw7yr3NYyGGuE349FuVnMvpI
	htTaZH+5i5je8XzFxpjhdR9voRa5galGmcrpPa7I3ruigTO1z+3EwWd87wUta3mjEtfsY/BNHVW
	vpJt+fsXljf0DYOA3Yu5qz8a0H78oo/L0QPzrnGge9GG0u/Itx8JMm2l8oKsDc7XnXWAFymlSsU
	6Y/Zvoa/4CDYhO/ZVhcibXQQqaI/groVZVoESKQmNRFD4UWE5E3lGVhxq0hQLZacszkFJv8ujbU
	qZgFvVzX5SpVBc6AWxuhKrmCjkNQDU91UbqoRrdgcDJfcNw00hoIdQmxN5O0oJBt7kNz86zUmOZ
	SfwinP7UyRpwJjDIhh86w39kZa/KWWGuAp+lfnzlKtn9eQEPbPbInEBoYSH8y1I2K9YdM2U8DNi
	UBAE0C3AcrTqLUOVGWMl4/9K+Nm5UhhlpAUNB6zeOCR/TDhVyp6bUpokZEUGN0UkXfyZhwdJvL2
	X1g724JLksnpFUWsZBRlEfJyvA==
X-Received: by 2002:adf:e011:0:10b0:48d:f99d:a0d2 with SMTP id ffacd0b85a97d-4abb2168f53mr10514425f8f.15.1795306152315;
        Sat, 21 Nov 2026 16:09:12 -0800 (PST)
Received: from infinity ([2001:b07:5d26:7a6a:365a:60ff:fe0d:cfc6])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-4ab5ffcad11sm13461872f8f.0.2026.11.21.16.09.09
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 21 Nov 2026 16:09:10 -0800 (PST)
From: koraynilay <koray.fra@gmail.com>
To: Namjae Jeon <linkinjeon@kernel.org>,
	Hyunchul Lee <hyc.lee@gmail.com>,
	Alexander Viro <viro@zeniv.linux.org.uk>,
	Christian Brauner <brauner@kernel.org>
Cc: Chuck Lever <cel@kernel.org>,
	Jeff Layton <jlayton@kernel.org>,
	Jan Kara <jack@suse.cz>,
	"Darrick J . Wong" <djwong@kernel.org>,
	Andrey Albershteyn <aalbersh@kernel.org>,
	Amir Goldstein <amir73il@gmail.com>,
	=?UTF-8?q?Pali=20Roh=C3=A1r?= <pali@kernel.org>,
	Lauri Gates <lauri.gates@gmail.com>,
	Christoph Hellwig <hch@infradead.org>,
	Dave Chinner <dgc@kernel.org>,
	linux-btrfs@vger.kernel.org,
	linux-xfs@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	linux-fsdevel@vger.kernel.org,
	ntfs@lists.linux.dev,
	linux-nfs@vger.kernel.org,
	linux-api@vger.kernel.org,
	koraynilay <koray.fra@gmail.com>
Subject: [PATCH 0/3] Add f*_xflags_{rw,ro}_mask flags to the fileattr API
Date: Sun, 22 Nov 2026 01:08:53 +0100
Message-ID: <20261122000856.536902-1-koray.fra@gmail.com>
X-Mailer: git-send-email 2.56.0
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Post: <mailto:linux-xfs@vger.kernel.org>
List-Help: <mailto:linux-xfs+help@vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-xfs+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

This is a follow up patch series stemmed from [1] and [2], splitting the
_mask change for the fileattr API into its own separate patch.

The first patch is a preparatory patch so that the code in the patch
after can be formatted better.

The second patch is the actual implementation, which introduces:
- fa_xflags_{rw,ro}_mask fields to struct file_attr
- fsx_xflags_{rw,ro}_mask fields and has_masks selector to struct file_kattr

These masks have the following semantics:
- rw_mask:
  * for filesystems: advertise which xflags they support changing
  * for userspace: specify which xflags it wants to modify
- ro_mask:
  * for filesystems: advertise which xflags they support only reading
  * for userspace: ignored

(ro_mask for userspace was also proposed as a "verification mask"[3] but
I left out that semantic to keep this patch series more contained, and
can be added later if needed.)

This allows userspace to not have to do a RMW cycle when using the
file_[gs]etattr() syscalls, avoiding possible race conditions and
simplifying their usage.

Patch 2/3 also introduces the missing FS_XFLAG_PROJID flag so that
programs like chattr can leverage the new mask API.
FS_XFLAG_PROJID is kept out of the legacy FS_XFLAG_MASK and so it's
defined as part of a new FS_FILE_ATTR_XFLAGS_MASK group of xflags that
will be used moving forward for any new xflag (like the one proposed in [2]).

Patch 3/3 converts fs/ntfs to this new API, to show how it can benefit
filesystem drivers too.

The series has been tested across NTFS, ext4 (with project quotas), XFS
(project quotas and extent size hints), and Btrfs.

Thanks,
koraynilay

[1]: https://lore.kernel.org/CAOQ4uxg8aVcWyNiFDk8djdn-M3xJcu_7-kRxVq9jjFsbcGp1ew@mail.gmail.com/
[2]: https://lore.kernel.org/CAOQ4uxjVQ9cjV=_jBjQtNg9zCuWUEJT9KNYMKV+1jwBkHen5OA@mail.gmail.com/
[3]: https://lore.kernel.org/CAOQ4uxjCN-ekd18R-soD8tkGFnXjK0S1VdSNhq9b3Ev6y8K9jQ@mail.gmail.com/

koraynilay (3):
  vfs: use goto out on error in vfs_fileattr_set()
  vfs: add xflags mask to fileattr API
  ntfs: switch to the new xflags fileattr API

 fs/file_attr.c           | 179 ++++++++++++++++++++++++++++++++-------
 fs/ntfs/file.c           |  63 +++++++-------
 include/linux/fileattr.h |  13 ++-
 include/uapi/linux/fs.h  |   9 +-
 4 files changed, 197 insertions(+), 67 deletions(-)


base-commit: 3857587d9d6fa44d40d1c73bde6a39f6f7a5216c
prerequisite-patch-id: 7af19117a27af492e3e525774310fb3a76700ffa
-- 
2.56.0

