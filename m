Received: from mail-pl1-f181.google.com (mail-pl1-f181.google.com [209.85.214.181])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C75AF40DFB0
	for <linux-xfs@vger.kernel.org>; Sat, 21 Mar 2026 10:13:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.214.181
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774087990; cv=pass; b=ku2g7GQJMEGHBMmkfXs1oBJDgLPi8aduwcPW9CzxU7blg3sk5zKJBv7kL+MiWTWAaUkjB+TcA2ZW3mzGCynybWaM0gy4LOdhP/wI4CyMsv5TKFH/+wvNZZVrSdx6E4VXR3T8T0FO2WaHo9IuXj1OJWbAJvbHzOEoWggfpYlvcL0=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774087990; c=relaxed/simple;
	bh=47DEQpj8HBSa+/TImW+5JCeuQeRkm5NMpJWZG3hSuFU=;
	h=MIME-Version:From:Date:Message-ID:Subject:To:Content-Type; b=WgJ0Wic7vIdk8hUbk58yOz3Ed1aH730nLd4LVs7rIh+BSaiU8QQlK0ho300f/dU4dEvF5pq0ETdo/js5Jbf2WDvE/2eK4ZY7F2TJztiCR+FIeORcIZDHwx5XSvWjjHTeKTk2gNA2H9bKjnYMlVtmonk2iU6oI91Kjzm7/SCTFsM=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=G3aqbHDt; arc=pass smtp.client-ip=209.85.214.181
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="G3aqbHDt"
Received: by mail-pl1-f181.google.com with SMTP id d9443c01a7336-2a7a9b8ed69so35164535ad.2
        for <linux-xfs@vger.kernel.org>; Sat, 21 Mar 2026 03:13:09 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1774087989; cv=none;
        d=google.com; s=arc-20240605;
        b=PFpe3i5KT5TBQWq5qEyEGT1f7z1GbyflVd5VtF2XUuYp9t3pTKe4FG5cRU8sqBxHij
         ov2M0r+XS3u0WVHoEUrDvlxk6J31loiVYkiRrGUP/HpSxVzLggjuu9MYMj0MyxZOOjon
         OAg49njgWL6O6MbWz6LefQJHJmvggGKuB+MtWalAX1SzrSIpe+D1mp8eHexzFAWjOu3C
         JSJpco27sHi/jZ8bC8Nlc7HO3jSbP7wD5mFLMPOrTxMYn/qyqVuIjl7OByFR1NaXAe81
         9marCol3EcHkRZx3YaLyvi0wPG75fP3G1EWRyguxtwJQsUHpIW1CXcDc87zzH0D4ObTF
         7LLA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=to:subject:message-id:date:from:mime-version:dkim-signature;
        bh=47DEQpj8HBSa+/TImW+5JCeuQeRkm5NMpJWZG3hSuFU=;
        fh=717UJfa65qmxQPHgXYe7gUuNhUmUVEsh3JzHptCWmjI=;
        b=GFmqldFjK14b+ztkwR6JWefZhMR/tfYYrUOYhNDsvkJVxz0hgKqrGrkz753bf4C/cF
         nA6jJ4BxEV4sB+AZdX/Sea+QOl2pFNXkwEI/HE/lRVxKvn9ImbDqPRsZWqd2xGO7Tzy4
         2fmqfwW57VGpgAdJqwIxO3+i+ZXNu4EDfkuVrR4BxlMW12e66x1gGddMhXk7CjMqSe1O
         RQl3IKMGDhSqAzwu3oCsAPHMvOR0toYwkB9QbLexD0YYUwFOSd7wijB8pkCnl4TGowUd
         iAVU50BWe8TlUTvFCXTs/lwD23AG9tfxwSSUipPs1sYA4B8JmHbU+uN7kkbvWdqjP1Qe
         DtuQ==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1774087989; x=1774692789; darn=vger.kernel.org;
        h=to:subject:message-id:date:from:mime-version:from:to:cc:subject
         :date:message-id:reply-to;
        bh=47DEQpj8HBSa+/TImW+5JCeuQeRkm5NMpJWZG3hSuFU=;
        b=G3aqbHDtEYMGqBbH1c8LV6YfEU6IoaSEmg/aXY/UR630bZmlYVPPSYVF6rpZxl4zcs
         YYhPhjVXb1D5Ynktj9pK+UcmQWTCLydn9ffGfBL5rDiK5KxaSsoMG0jZiyegECHUtIMR
         tt8p7EjbT0utkO66leGUCzPnKQnyMPzFDWrWiZnChWi8lRjr/s6l6nIezYoTnRPZJ7sH
         ncD9FREwpXt6fMUu5pQMUaCKgKv8pjACxJOoaLTzEKeHubZKQ9JA1NMfYP5KlZGSlspf
         cKP6M3eQXIRqou6OhYXd/bV+oknjVdO1kePMlBkAEv7ZAsxGfdAGASzZMirqtB0C6xvS
         OaTg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1774087989; x=1774692789;
        h=to:subject:message-id:date:from:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=47DEQpj8HBSa+/TImW+5JCeuQeRkm5NMpJWZG3hSuFU=;
        b=Chbhv32qKZU83YS/eyK/u8kqyDsfir/bJEcVAvJ7rJid6pCdhi+9sCTcQwThMVTiPa
         TdwToX2sCRI5nInFK4hFiXztt5HcYmSsMJGD0PxzDBRl7Gk1C8Pi+5nxhfzjhBMOaPY1
         GRql3P4Th0Q6loPxCl4/uPlFephfVHXIv4qh34nDY4CYuF9+v6A27qVEeO5TCarbQ0HA
         AAYnFTVMVElU0iL4o75ay4VacRbfiSVLS14+dKyoV0BJSUhqUK1W/bFvYkrXb7CbcrvH
         lcX0bAdfuGoXZ6a2a0RyWDKmipp50kFCquG1Yd74JoyHr4GkIDl7lZgXcO+pSq7oq8xM
         vfHg==
X-Gm-Message-State: AOJu0Ywo4SjxZiZRIWu2y4REDpydyrEMHVvwG4KXjv0vWdUUJJKIgSWz
	pQ1OZTRM/I4hmgZwb9vKU8dQa5wMAdLNkrOhowTx4dYqarfTpx3j8U2eVuBh8G9eMF0mHq5GGa5
	n7/Zu5T4i2f6S0iEuWOqX8mxwxxZXQJ9kTw==
X-Gm-Gg: ATEYQzz66Yd/t8YL5NkLZlDfmQ9v/ahI7Wlqq+o7eErqYEmXEMlFRVkrb98leqqTt7o
	Ub+p4mvGx+0fSXHSvcCUb+KsTstdBbU9C4QbXAs2DIXfqx2hKB/eL2MTraSkY/bgDoo3IRzIPsV
	8Q9pSVVmfOfJRT0y/QwqT4zp4PWUpEW+KR4Rhz+DUvBqWJ33vXEiEJW0p1s2F/rrWP/q2XDoEq0
	YIF0J2DDia7VH1Cd5G1DLyZNmx7kzMVgMK9EkmmCRGNzRgyByb22c1EUAN4egt7T+My5zy+lmFJ
	y2yKeedOBgL4+brcn/1xF5E7W5qS85SKXmMKlz0=
X-Received: by 2002:a17:902:e5c2:b0:2b0:41eb:165e with SMTP id
 d9443c01a7336-2b0827c0af0mr58561265ad.38.1774087988858; Sat, 21 Mar 2026
 03:13:08 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
From: Jorge Bastos <jorge.mrbastos@gmail.com>
Date: Sat, 21 Mar 2026 10:12:57 +0000
X-Gm-Features: AaiRm514S-9OOtnAj5OzDKegyzaiEWFDYxMOUBOKlwqvUfCCBgTl5-MqwudSeH8
Message-ID: <CAHzMYBQQ7peSaa5nKU4iD-V=iRL9NS=12Uwg2c7D1sK9i2+y3Q@mail.gmail.com>
Subject: subscribe linux-xfs
To: linux-xfs@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"


