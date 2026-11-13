Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794580200;
	b=oEzxKbHfHcz42b8USJg154JpZ2IDnIQ7hJgcI6wLihka0QXY15ne3wNN7/n5K7iiKrSB
	 RTzyZYfhXvdyndlhnsm6+6F9mlXjd1R9PAf2U+AqEBq50dIaufVISjOFEWrFvR/mE88CJ
	 /Fyh7zEggO3PAJF+livPysaF9w1m9LZGoZEHUx4rLa4pGHbBy5etDRnZ1Ie462xar249z
	 BqCl0FhsaoLV1VXWzukFZi/f1hbGzksiMnedPAmatnwJEt2seTbkZXH58JWbWORXujR5R
	 R5Mh03OglrWrpR1CI5W/rX3P9C1RtxRWbhrJ9BO2FYOBr9rgreFyUlIIyo1GdUQJXLQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794580200;
	h=Received:DKIM-Signature:Received:Received:X-ME-Sender:
	 X-ME-Proxy-Cause:X-ME-Proxy:Feedback-ID:Received:X-Mailer:
	 MIME-Version:X-ThreadId:Date:From:To:Cc:Message-Id:In-Reply-To:
	 References:Subject:Content-Type:Content-Transfer-Encoding;
	bh=r44VGVXjpBZvSPH3AAkVDqbr/+AiQktps6NDmxi0hik=;
	b=pC1mA31+Xz4GRVXFTO3dPfF8SzWtwBqckdCfaYnaXyZ1Zds9Oc+1HJxaeRyPYjG4sZcP
	 /elgXjz/hZ1LtAjeo6eF75vk+hhnikIMuzpsi/+NSLwlUJmcrTRE4dv2xaz4WUgQ651va
	 IdaSM4GQSZUlkcsTDQqr9TDgZghwyH+Z471brk0G+5zP+eL+086iSP1SU2Bkfml7s9CcS
	 j12ArarwZ4WnLeTwuoVTfrTWO04LB4kF5H1bw8xFWRdwfeV+6nUuEmjUwXeaTCjJIlffq
	 xF1qA/8oepjEvrmWuZe1WF4XKH3LE8Szl9hPNVFZlF1wLzM47VyWWYn3jxQusIAVvbQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=cabKdAfX;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 25BD3606A335;
	Fri, 13 Nov 2026 14:30:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=cabKdAfX
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 095671F000C6;
	Fri, 13 Nov 2026 14:29:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794580200;
	bh=r44VGVXjpBZvSPH3AAkVDqbr/+AiQktps6NDmxi0hik=;
	h=Date:From:To:Cc:In-Reply-To:References:Subject;
	b=cabKdAfXY7aGxVymE5PIFWVdOhyZVGq2bOqJkmXAH6qWZireQnyao0TX/kzgsiXOc
	 T2s7HI0Z9PlHVuMCGJ2d2DSCusaNOIawK3+rUnv/DAjjxfTj7oInwKAaBrefXEoUER
	 DDqhXYoJ3IhyhrTaShc0zbxIJxQzIaQuuXdk3C6xXQj2V2EwZQF4ObiNBuvfctM9dF
	 OIY8neFsqvmA09frvGBB8iSTuEvnfSq4EMNp1njEtxYx/WwUGPiR0A2HceiBKlUt3a
	 ryOCdHQlltw5FIcBupvvKEzoukoZC1OS2jBdYVX13IV/ctQyP6szu7HwJgHUFcan4b
	 Pn7A1Juy33PCg==
Received: from phl-compute-10.internal (phl-compute-10.internal [10.202.2.50])
	by mailfauth.phl.internal (Postfix) with ESMTP id 4ED74F40069;
	Fri, 13 Nov 2026 09:29:58 -0500 (EST)
Received: from phl-imap-15 ([10.202.2.104])
  by phl-compute-10.internal (MEProxy); Fri, 13 Nov 2026 09:29:58 -0500
X-ME-Sender: <xms:5h73ajHbLgXGptB-dLn7JolU98xqZzvOYw5qiuUWzN2H88vb2mSYCA>
    <xme:5h73arItnLhI9Lm7rBE_uEwXyrLRPez3-oCsJnuPte095JZZJGJX7SNvcpr2FPe5j
    VCKhzJvUfwORn2e4PKQZLgr6bBGF7dbq3t8atIUb5yw-OBySTQp>
X-ME-Proxy-Cause: dmFkZTE/tOQp30OUl6utnn/w64DIjqD/RRWwsaN4vYA/Um7X8Hi0+38VBMJkOTI7il1dTj
    9GDGmQ/tntw9pB4r639GENnQSS374aTm40SaYFhBJb3/rc4NqayYCYuv1cKjeuZg5ozGVy
    9jm7SGRy4mjVCAtZDk0OdyfrgbxcxBpVg14dRsf0FSl7GYPyf0jxpJ1PaglA/Ahgitf50G
    tYf1fz57lsz+ArTGdypZQerbtMPD5NCxF8t0eYyQzLLvMxL2aVj/hfqm5mTSRMEgkI7f8M
    ja5juPSxNHeEwWmT3TeN7Pc0PhZPmsRgLvOF8/1AqpMQl194E1ME6BcwdlmnUUYYVf1pOl
    f4ISQDtRi/ca9iO5bylZkJ5n1ii862vn5VxiQYK2st5/K9VvhXIWxsRjxNDQyrrzSQaIIX
    qYNHGwJdBf2n0IED9fucthumcfPCnuIFgE5bW7gcKB9i2tv1KP8j3wAivqD+M0Jb3EUUfz
    5UPyiEYvfAcy0Iq0oB8yJFdexYPJ6OHATFxTYEKvNs3dyHhXcN4cH1S15eCJSu9yQh9Pvo
    Aw2PRO9mukA+Ppx9rHF9R6ZvFgc2COflEqJVrAbgJs9LwQh2tiR7063LZB7buOUx6/inml
    cbuYc7B9acJtwWkXY4E+AwHyPl/Xc1Q4rb75SkDGZYUHQIizezNpW/19N+OQ
X-ME-Proxy: <xmx:5h73alzwDHiX-GqJeiEDrfQ4osAGX0cKV9iJhjL_T68AiBQRTwMi_w>
    <xmx:5h73ahWwQxeiluvyUOtPmRU0tBvZKrM12OZ6CAfurTRXRDl05eO8_g>
    <xmx:5h73aqrMz5qopQ5fw7RU9o095_0BPg80zPUHkwETH8klJEEm4PruSQ>
    <xmx:5h73amc9f7nbs-9G9HBwNcRIuxYjQ-0rEV4palYsrSyfjiX9oltsSQ>
    <xmx:5h73agEuLlqwQZTcPwpye9FI79QIQundgG14hhc6Npf2nRtwNxjRHBbv>
Feedback-ID: ifa6e4810:Fastmail
Received: by mailuser.phl.internal (Postfix, from userid 501)
	id 23F69780075; Fri, 13 Nov 2026 09:29:58 -0500 (EST)
X-Mailer: MessagingEngine.com Webmail Interface
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Post: <mailto:linux-xfs@vger.kernel.org>
List-Help: <mailto:linux-xfs+help@vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-xfs+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
X-ThreadId: AhoMoQ4eTUpJ
Date: Fri, 13 Nov 2026 09:29:38 -0500
From: "Chuck Lever" <cel@kernel.org>
To: "Jeff Layton" <jlayton@kernel.org>, "Jan Kara" <jack@suse.cz>,
 "Christian Brauner" <brauner@kernel.org>
Cc: linux-fsdevel@vger.kernel.org,
 "Andreas Gruenbacher" <agruenba@redhat.com>, gfs2@lists.linux.dev,
 "Mike Marshall" <hubcap@omnibond.com>,
 "Martin Brandenburg" <martin@omnibond.com>, devel@lists.orangefs.org,
 "Dave Kleikamp" <shaggy@kernel.org>, jfs-discussion@lists.sourceforge.net,
 "Carlos Maiolino" <cem@kernel.org>, linux-xfs@vger.kernel.org,
 "David Howells" <dhowells@redhat.com>,
 "Marc Dionne" <marc.dionne@auristor.com>, linux-afs@lists.infradead.org,
 "Miklos Szeredi" <miklos@szeredi.hu>, fuse-devel@lists.linux.dev,
 "linux-block@vger.kernel.org" <linux-block@vger.kernel.org>,
 linux-nfs@vger.kernel.org, "Eric Biggers" <ebiggers@kernel.org>,
 "Jaegeuk Kim" <jaegeuk@kernel.org>, linux-fscrypt@vger.kernel.org
Message-Id: <8f7083c7-2a37-4a41-8cdf-5504dd889f44@app.fastmail.com>
In-Reply-To: <bda5f50707205ff7fa55120247fec46300d420ad.camel@kernel.org>
References: <20261113083336.15152-1-jack@suse.cz>
 <20261113084700.739002-24-jack@suse.cz>
 <bda5f50707205ff7fa55120247fec46300d420ad.camel@kernel.org>
Subject: Re: [PATCH 11/13] nfsd: Use inode_or_folios_dirty() for dirtiness check in
 wait_for_concurrent_writes()
Content-Type: text/plain
Content-Transfer-Encoding: 7bit



On Fri, Nov 13, 2026, at 8:08 AM, Jeff Layton wrote:
> On Fri, 2026-11-13 at 09:47 +0100, Jan Kara wrote:
>> The check for dirtiness in wait_for_concurrent_writes() is racy because
>> I_DIRTY_PAGES flag can be temporarily cleared by
>> __writeback_single_inode(). Use inode_or_folios_dirty() helper to avoid
>> that. This also makes sure inode timestamps properly persisted when
>> lazytime is enabled.
>> 
>> Signed-off-by: Jan Kara <jack@suse.cz>
>> ---
>>  fs/nfsd/vfs.c | 2 +-
>>  1 file changed, 1 insertion(+), 1 deletion(-)
>> 
>> diff --git a/fs/nfsd/vfs.c b/fs/nfsd/vfs.c
>> index 56c49b5bc5bb..a314ca39272f 100644
>> --- a/fs/nfsd/vfs.c
>> +++ b/fs/nfsd/vfs.c
>> @@ -1249,7 +1249,7 @@ static int wait_for_concurrent_writes(struct file *file)
>>  		dprintk("nfsd: write resume %d\n", task_pid_nr(current));
>>  	}
>>  
>> -	if (inode_state_read_once(inode) & I_DIRTY) {
>> +	if (inode_or_folios_dirty(inode)) {
>>  		dprintk("nfsd: write sync %d\n", task_pid_nr(current));
>>  		err = vfs_fsync(file, 0);
>>  	}
>
> Reviewed-by: Jeff Layton <jlayton@kernel.org>

Acked-by: Chuck Lever <cel@kernel.org>

-- 
Chuck Lever (Come to NFS bake-a-thon! https://nfsv4bat.org)
