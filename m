Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 46A6138331B
	for <linux-xfs@vger.kernel.org>; Mon, 24 Aug 2026 21:41:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787607664; cv=none; b=KVZwavkavvtS9h/oqXZGSCNa6IxVsCIhp1XpwWgSu3N5j6GaHeqU7NVC7CxlENvtUOZowYyQYZnF+Cg08LfkmgSefdH9mpK2/TBVdh6IqYsp/pXhJOnXlmsNIQLE2oPu+0KGmkkhB1ZkHL46JDGj7YJjepsscd1NtJAyHA8DivY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787607664; c=relaxed/simple;
	bh=hRyn4g8ocb22vZy2VimB50eHxFv9RS+2h/KYdyBH/ZI=;
	h=From:To:Subject:Date:Message-ID:MIME-Version; b=l3rKm7Acc0JYevRAT9c6HETW3WGE570uwe9uNMWvtIoCoSirOUm0RfZ5XgBzSSMveg/Z+FdGXZzBmvWVKO6lH+s+L+5IsvhgisCYqTwVEI9q3PjEqYWbwRUsd4XE81CilJjnOVXSRjvAKjGCr9nflDzcfdI0pwrvs9d8SzN1b0I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=cN9UYU+5; dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b=oYMCk0Xo; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="cN9UYU+5";
	dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b="oYMCk0Xo"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1787607662;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding;
	bh=hRyn4g8ocb22vZy2VimB50eHxFv9RS+2h/KYdyBH/ZI=;
	b=cN9UYU+5t5oeM23hxPLM5AXTS5ZEUHj9HoWyhLdggjcpAsArMJYZ2gnBL99T7UzQFuHVEZ
	QOy61POxde6vHBo8dIjvJCoSmbdCQkLMosdlbq9zo19LzErS9J4i/02CisMehzppStwdt2
	i05WtpXB0SJeBMu3WsUQncCaQP+Iv9E=
Received: from mail-oi1-f200.google.com (mail-oi1-f200.google.com
 [209.85.167.200]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-687-5G4paqoyP6Swm6pwHofobA-1; Mon, 24 Aug 2026 17:41:00 -0400
X-MC-Unique: 5G4paqoyP6Swm6pwHofobA-1
X-Mimecast-MFC-AGG-ID: 5G4paqoyP6Swm6pwHofobA_1787607660
Received: by mail-oi1-f200.google.com with SMTP id 5614622812f47-4b28dbf4197so7875044b6e.2
        for <linux-xfs@vger.kernel.org>; Mon, 24 Aug 2026 14:41:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=redhat.com; s=google; t=1787607660; x=1788212460; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:to
         :from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=hRyn4g8ocb22vZy2VimB50eHxFv9RS+2h/KYdyBH/ZI=;
        b=oYMCk0Xor+rekX6oeROaKQaHw8To1McAtlW0T7CrAIV8rDA7CDHEp/KLxJwtuYLpGh
         9Qc+usCWszWZZiQzOhPWAjdR3GuAvBGH9QemMDkmrVePYaZQ3UbN7B678Q9rfJJ9gJ5e
         SDuJxOTzLLTRCNjx/KecI2FIWzSNqDTXp9A/28WifZzdHghLAD5LJMyyYTbZLH+UDxfU
         6dmL89LwMz99b4BvwepajtrHtBoXfM8hQM5n0zNEU5kVD/Dbzqn1MUOybijzem96nisX
         /WLPVYkpSOyUVMUtiF+An4qvITBc2MY1XlyS1BLDyG75P5JEXfPJCkkGyGvVzyo+LVq4
         PWHg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1787607660; x=1788212460;
        h=content-transfer-encoding:mime-version:message-id:date:subject:to
         :from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to:content-type;
        bh=hRyn4g8ocb22vZy2VimB50eHxFv9RS+2h/KYdyBH/ZI=;
        b=lYu/EPhaVggO0uY3runXXLsWTTCEcsU7+tTOY6l4gpcL9Pfjn6va8TNRckZnKMZeND
         J8uq4eOtcCo32wQoGvk6CYHAOfmWFEAB8tHqufyDxbXb9p57YeSI7es3IgFIbUoE/Bn7
         QviHMRux6S592GqFAbhbB7vVuafLJ6183RqTdHN6sfZ8maqmyKBn382fPlXpo53zpR/K
         k6XGAxhqa/2UmP7D1KqtzzyNhpLTBJwuwnugyh+4SXwT/PW4fJWSrvY+VxGh6rRBn0Tn
         HxOZusEzvH1itGHEpDjHHvnMc+3AhCFpJPzNQ1baN9xj4SdnBgNgBFW86w5YzXqDZPUV
         docw==
X-Gm-Message-State: AFuF++lvlJwgb3RKDt7SUwFRCA+QGoByHaQMtdobh3i29oXvKUCRst0c
	emq+TciqVBLFHt91X2PsYfvB3l4WGN9Emn8pCJlA9tOU8LWFc77KdEwx2Q0n5yjar2aqhQH67r2
	ktaFeIOMkaekpT92AgEk3X4+PzcFo4mhiBMx3QhJVUtixWopIfQ9qqiuQx+3SU+pqGquI7BYiWp
	0GOWEYKGsTeyAjhs97huDnXyPMblBTu0hruN+WyNm8JxapTuw=
X-Gm-Gg: AR+sD13DkOWRFJg8i2j8j8zHk6t0B76uT0Wnrf8BpDnoeEyg7XYhR/IqeNMeaC9pBlw
	ffU7tzg6rcW31tA1GMJeNacpKWbFVlbxD9NEaC04A1wfsC2MeR/TrEVre9dofrLUm/bWE15MQxK
	rXaGNueOPbtKr7UcPiAsikkGf9hDQspESBLlhmLvK7IyJ1jwOKPU0uBedP82oBruZl78jd9Na+R
	mfO5VkrW5Ae93duTiXCFIkayWFn7RKPJSHlrXj9TCjC8DJwYT8Jwg/yBbJ7lk53HATAnXMdo7Kp
	jxKyjCc+l2T1qMMWOO7jlMReqbTwLmlZ8NboWpWQTrEAfUYS+1GehPoYslfkPKcbxsfbDYvXFw4
	s/C6Bn6YRtXLIH5c08yivMpXaFejA4BjKQvupGC/4VBs=
X-Received: by 2002:a05:6808:222a:b0:4af:5d69:1cb4 with SMTP id 5614622812f47-4b35083291bmr2204410b6e.15.1787607659830;
        Mon, 24 Aug 2026 14:40:59 -0700 (PDT)
X-Received: by 2002:a05:6808:222a:b0:4af:5d69:1cb4 with SMTP id 5614622812f47-4b35083291bmr2204369b6e.15.1787607659253;
        Mon, 24 Aug 2026 14:40:59 -0700 (PDT)
Received: from big24.xxmyappdomainxx.com (97-127-68-83.mpls.qwest.net. [97.127.68.83])
        by smtp.gmail.com with ESMTPSA id 5614622812f47-4b32c8355e4sm4174860b6e.11.2026.08.24.14.40.58
        for <linux-xfs@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 24 Aug 2026 14:40:58 -0700 (PDT)
From: "user.mail" <sandeen@redhat.com>
To: linux-xfs@vger.kernel.org
Subject: [PATCH 0/2] xfs_repair: improve caching in the face of ENOMEM
Date: Mon, 24 Aug 2026 14:58:58 -0500
Message-ID: <20260824214056.400740-1-sandeen@redhat.com>
X-Mailer: git-send-email 2.55.0
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

There are problems with how we react to cache allocation failures that
are more apparent before:
6b6239689e36 ("libxfs: unmap xmbuf pages to avoid disaster")
landed, but with enough pressure they show up again.

Two problems: cache_expand has no bounds checking, so call it enough
and c_maxcount will overflow, which typically results in an infinite
loop.

That can be triggered by the fact that today, an underlying ENOMEM
can look like a "cache too small" return, so we double when that
won't help at all. Do that enough times and kaboom.

I can trigger this with something like:

mkfs.xfs -d file,name=testfile.img,agcount=10000,size=1t
echo 1000 > /proc/sys/vm/max_map_count
xfs_repair -n -P -m 1280 testfile.img

to force an ENOMEM from the max map count, though the actual
max_map_count value needed varies depending on the machine I'm on,
for some reason.

These were quickly tested with ./check -g quick

