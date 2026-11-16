Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=103.168.172.151
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794873717;
	b=qPaqWZUO4yHZz2EVWRA5GTpc20JIlrkNgOYh7J6aIwQpQCy+xyj69AatZT9zaXYet3cX
	 9ADQOmaU5RteA1viumC4SXBt10wZp36MXZ8bneYlh/iGWNELUMgdn+C0VIkQCNt4/onMd
	 plynz/NSTB3ur3/QAoDHzpK0YlC6E3p66E8EOIGogApDB7W0yBE+HAfNsuyiUEGKaMiym
	 AEMgkEamd+LvH97VRfqvWBoL9EyOXwvGTutpyxvHOkwQ7SbURK3VJkc0EqwqonNFAqMC3
	 QeW2jAwd5t43iyMbDWGySZTFEqdFDIGY8KwB839fi5aX0t9fHNhCuAopHcSgfrWGcsA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794873717;
	h=DMARC-Filter:Received:Received:DKIM-Signature:DKIM-Signature:
	 X-DKIM2-Info:DKIM2-Signature:X-DKIM2-Info:Message-Instance:
	 X-ME-Sender:X-ME-Received:X-ME-Proxy-Cause:X-ME-Proxy:Feedback-ID:
	 Received:From:To:Cc:Subject:Date:Message-ID:X-Mailer:In-Reply-To:
	 References:Reply-To:MIME-Version:Content-Transfer-Encoding;
	bh=C7sWl1wG48MQ07r4zoW2vh68HNiuHxVXcgb2L1fNbYE=;
	b=yDgl9BHaqGz2rZFg9YokzMabWLzIgQpoIuYbIyVSS/pYzjvmVvF+e4QDZ7fyZfuKLXa2
	 4TG2OQxkY7SvXjZzrEaB5pktH49Jhj4LTyHKMiGkW0WKc2u1NRKWfG2g5AEN42pyQMp/9
	 tkui6whELS1LI77WaHtN9TJDBVhfKp/l0fodXrCtBBnNySUy1unBRd+4OOa22vWiJUOnj
	 5U53PsRhKZLXA8JcbrjTAzQ+C9Edxn8ZoSX42VuGBmhSTwZ3oKp82gae3uftSstwpXjPh
	 e6k3CH+AuRMO2dsGsnwverwQqzlQe7kPFaSr6f5Jmn69GKXAcfqWdti2PHVRUPv/yGA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=ownmail.net;
	spf=pass smtp.mailfrom=ownmail.net;
	dkim=pass header.d=ownmail.net header.i=@ownmail.net header.a=rsa-sha256 header.s=fm3 header.b=0GAKIdqw;
	dkim=pass header.d=messagingengine.com header.i=@messagingengine.com header.a=rsa-sha256 header.s=fm3 header.b=hDWO0Tpk;
	arc=none smtp.remote-ip=103.168.172.151
Received: from fout-a8-smtp.messagingengine.com (fout-a8-smtp.messagingengine.com [103.168.172.151])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 92CB8606A31C
	for <linux-xfs@vger.kernel.org>; Tue, 17 Nov 2026 00:01:56 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 92CB8606A31C
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=ownmail.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=ownmail.net
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=ownmail.net header.i=@ownmail.net header.a=rsa-sha256 header.s=fm3 header.b=0GAKIdqw;
	dkim=pass (2048-bit key, unprotected) header.d=messagingengine.com header.i=@messagingengine.com header.a=rsa-sha256 header.s=fm3 header.b=hDWO0Tpk
Received: from phl-compute-03.internal (phl-compute-03.internal [10.202.2.43])
	by mailfout.phl.internal (Postfix) with ESMTP id DA908EC0889
	for <linux-xfs@vger.kernel.org>; Mon, 16 Nov 2026 19:01:55 -0500 (EST)
Received: from phl-frontend-03 ([10.202.2.162])
  by phl-compute-03.internal (MEProxy); Mon, 16 Nov 2026 19:01:55 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ownmail.net; h=
	cc:cc:content-transfer-encoding:content-type:date:date:from:from
	:in-reply-to:in-reply-to:message-id:mime-version:references
	:reply-to:reply-to:subject:subject:to:to; s=fm3; t=1794873715;
	 x=1794960115; bh=C7sWl1wG48MQ07r4zoW2vh68HNiuHxVXcgb2L1fNbYE=; b=
	0GAKIdqwLEVc4s2GojNoid6jRJ4e9UF1YhZqqdeXkcLiCeOdQOkFEK1+1J6MiywO
	Ctc47Sd4XX5N1RAywkHl2itA08MmiYtpqAj+4BZII0e/cECUcDT7LEM567MZxPSb
	AV7CzOR03NLhDeRszgE8MEIKuMKeldIhBjcTTKfd3wgsHRhDw+y5SR8gika4vKiQ
	aq03JqD0ACawK6iuwEKWkpEKmkHGSqdae95BHtW49d448zOtgOGCMxWfmzwIyhGV
	/GIg5Y2QsHRd4qQVgJDt7kDnWE2bptPeg3Z7o0JVM8I41UgIAqdLP3BosXAMseTV
	DV5ONpYrJ+TBTLJ1eoMp/A==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=cc:cc:content-transfer-encoding
	:content-type:date:date:feedback-id:feedback-id:from:from
	:in-reply-to:in-reply-to:message-id:mime-version:references
	:reply-to:reply-to:subject:subject:to:to:x-me-proxy:x-me-sender
	:x-me-sender:x-sasl-enc; s=fm3; t=1794873715; x=1794960115; bh=C
	7sWl1wG48MQ07r4zoW2vh68HNiuHxVXcgb2L1fNbYE=; b=hDWO0Tpkh8TVL5xtZ
	kfX755qHlI7pUIVjrsV6ptN3irpKvydI/BjoMhrIdt811u4ENuIq0R+2ULRWYb3t
	GmSBS98/6kCPAjNVfTK4mwPW1SbzbNICVBiPfRRoaeOKxqIvGoF/c7SHNOQuGXgc
	ZUPd5/H29vm/VF2s7BBguXzwXcvB9deD36iIQOcjgr01p8jRHvRplP6HZLU1pniG
	WPCbe4s1yC6oQOIuFpp9YNZNF6fse5xdBYxF7vNWB4+EydAy8IaHl7hUAl5+lBhB
	HE0G3cns3+krFT7QxgWOboCPbGxJudxmbVasRHBdK96wu4Ye5gbsc0mQxnhP7fPP
	cfa8w==
X-DKIM2-Info: draft=ietf-dkim-dkim2-spec-09;
	repo=github.com/dkim2wg/interop; date=2026-11-03; sw=lmtpprox;
	action=sign d=ownmail.net a=rsa-sha256;
DKIM2-Signature: i=1; m=1; t=1794873715; d=ownmail.net;
	mf=PG5laWxiQG93bm1haWwubmV0Pg==;
	rt=PGxpbnV4LXhmc0B2Z2VyLmtlcm5lbC5vcmc+;
	s=fm3:rsa-sha256:ob9tAMiDalg2LJO0iuwM0D2SFvA3sOkVw6mrZieU3LF7zRQ
	nX0YoQT1pn0JIkIEsFYqM1Ey+vAeLhSnwyN5Wrjqq2lGuyQAEgkPoqhQkLPPOVQ1
	idq8oeDx09CBvwbqdasdBz3A+HNMQhHGPxMHc88k7curAPMkxPq8Ap935SpQv/4T
	ru3yCWU0jw1ueHutNEmqanwEdquHVB2tj5r37RDXdjPvotINIXfYmKzk5zeP2YtX
	rJxLj0w9Tq7DHIJ6B0CJnIoFXgJtQCOKAFLVVeTx4JgKIvVmeJOw2YGNEyK3nLDP
	KPBj/C6hdYs0My2ydqzm5GksQ0lKxNMEH+s9acA==;
X-DKIM2-Info: draft=ietf-dkim-dkim2-spec-09;
	repo=github.com/dkim2wg/interop; date=2026-11-03; sw=lmtpprox;
	action=mi-m=1; hc=12;
	hn=cc,content-transfer-encoding,date,feedback-id,from,
	in-reply-to,message-id,mime-version,references,reply-to,subject,
	to;
Message-Instance: m=1; h=sha256:oMgQUvucOl4P8cRbGNSDfSmjEMYlFoatWXuIC44BE+U=:Xd1WqezOWR4RGPff0oXZeRAR/TSzcmc9gClT/ovY9uY=;
X-ME-Sender: <xms:c5n7auHIDLqext--NfPK41UrohZQXd0SzE6AZTWr80YVP8AoZStPnA>
    <xme:c5n7agpfKZ_bWH9UfTqc6QV80jgqT3Cxw-8pzDT6ibfG1F5tyRHJfsNPCObMuDUUz
    Axt3fUdqUgPVR1XIcbShEMrSsxQx1YSynW7FPX4cxcTGzOeiA>
X-ME-Received: <xmr:c5n7asx3Z9RUj2zvBcr2ZzYcKB_mLlXQ-_z0xDfiv6lH4YgDy0VEMsJXbKTX982XKOObdKynv5fUkjnPAQ7BoXgEb94PGgc>
X-ME-Proxy-Cause: dmFkZTEWLllwmZbCQ7cO93As6sGHtjiFdYj9k/VSqMvUwk1xfk9pKn/ZCX7mnpLkIaqMef
    K/82szmVYemJN/I0DCAIOCHeaPZ7/Xa2GnBqk902ewdx8hjF22LzMBgW8kwMwZuhDEqmG+
    fRzfUtzcgzHNqdnt0hptgxxppIMFQUfVlAsIvg7fvTNv54Da321pj6NeCTNh6yP98D0Rix
    0qUujhXor+6vA1uX99KaZah7Remd9bF8xjGXqzB2MsscQiqTyvs6dLxlge9fkMF8nj1I3u
    +RSOpU+TvlDvjmsK8NtReLJ34nN/1FLS6YOAknIb84eISWftGKSVwY1LnVjpVMr2cR7DsZ
    w8Wb5rwjaydSGelossxx6bl1V7hOhKVIq+toFprLFYhRN/SlwVDMmaYKduO57Gh7OaGuBF
    h0J4sIrwb2zt8R9hW4hgNqcN8fzRhYzaDBPcxdVTtNH2vUX1m4VQoIpenYJuGlyjzLN8sB
    wi/kGQQCcooy0DrWZfM2ov3GXkEVgq5I5zBJSiuy+vPMURU0NBtPZQS/3EdbHTkVso2+v4
    Ckv+2iECJM88DmP71AxqjfON8WBYjJIHFkY7G93aYb/jDcLJHw/cEvt0enpH8T0capz27l
    7RHejCjOiJI++LMcjLuNNKGl98A5MSAixcFcvWSPAd1YIjZgNtMRDKNYJgpw
X-ME-Proxy: <xmx:c5n7aqzxemjS9U4i14HWz_7__2CGVeJd1tw-oWJDEKQSsotVnV7kDg>
    <xmx:c5n7arQLLyrbTJvbO20jPnJTo41ac5-vdVcPNcnbsMdF1dKQLTjPAQ>
    <xmx:c5n7atN66DenQEH96djIUqJ5Zw6Bk0MjIDbmoJsZlIcD-oCpa1d04Q>
    <xmx:c5n7amQhmLWxxD2dZ3fFuI1Epj5bjY1tlmr-dTsDkRq6C0NXp3s3nA>
    <xmx:c5n7aosnP57ugyhY2Otjf1KpVZNHti6cwXLd9I_thE6BHShMSvWCjukE>
Feedback-ID: i9d664b8f:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Mon,
 16 Nov 2026 19:01:50 -0500 (EST)
From: NeilBrown <neilb@ownmail.net>
To: Alexander Viro <viro@zeniv.linux.org.uk>,
	Christian Brauner <brauner@kernel.org>
Cc: Jan Harkes <jaharkes@cs.cmu.edu>,
	coda@cs.cmu.edu,
	Jan Kara <jack@suse.cz>,
	Richard Weinberger <richard@nod.at>,
	Anton Ivanov <anton.ivanov@cambridgegreys.com>,
	Johannes Berg <johannes@sipsolutions.net>,
	Namjae Jeon <linkinjeon@kernel.org>,
	Hyunchul Lee <hyc.lee@gmail.com>,
	Carlos Maiolino <cem@kernel.org>,
	Jeff Layton <jlayton@kernel.org>,
	Amir Goldstein <amir73il@gmail.com>,
	linux-kernel@vger.kernel.org,
	codalist@coda.cs.cmu.edu,
	linux-fsdevel@vger.kernel.org,
	linux-um@lists.infradead.org,
	ntfs@lists.linux.dev,
	linux-xfs@vger.kernel.org
Subject: [PATCH v2 3/4] hostfs: don't d_drop() before d_splice_alias() in hostfs_mkdir()
Date: Tue, 17 Nov 2026 10:55:00 +1100
Message-ID: <20261117000115.1433875-4-neilb@ownmail.net>
X-Mailer: git-send-email 2.50.0.107.gf914562f5916.dirty
In-Reply-To: <20261117000115.1433875-1-neilb@ownmail.net>
References: <20261117000115.1433875-1-neilb@ownmail.net>
Reply-To: NeilBrown <neil@brown.name>
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

From: NeilBrown <neil@brown.name>

hostfs_mkdir() uses d_drop() and d_splice_alias() to ensure it has the
right dentry after a mkdir.
d_drop() is no longer needed here and will cause problem for future
changes to directory locking.  So remove the d_drop().

Signed-off-by: NeilBrown <neil@brown.name>
---
 fs/hostfs/hostfs_kern.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/fs/hostfs/hostfs_kern.c b/fs/hostfs/hostfs_kern.c
index 613146e76dec..7cf25c29cb78 100644
--- a/fs/hostfs/hostfs_kern.c
+++ b/fs/hostfs/hostfs_kern.c
@@ -700,7 +700,6 @@ static struct dentry *hostfs_mkdir(const struct mnt_idmap *idmap, struct inode *
 		dentry = ERR_PTR(err);
 	} else {
 		inode = hostfs_iget(dentry->d_sb, file);
-		d_drop(dentry);
 		dentry = d_splice_alias(inode, dentry);
 	}
 	__putname(file);
-- 
2.50.0.107.gf914562f5916.dirty

