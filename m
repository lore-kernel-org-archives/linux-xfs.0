Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="JE8ud65k"
Received: from mail-ed1-x52d.google.com (mail-ed1-x52d.google.com [IPv6:2a00:1450:4864:20::52d])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 64D62F1
	for <linux-xfs@vger.kernel.org>; Fri,  8 Dec 2023 07:01:05 -0800 (PST)
Received: by mail-ed1-x52d.google.com with SMTP id 4fb4d7f45d1cf-54c5d041c23so2992749a12.2
        for <linux-xfs@vger.kernel.org>; Fri, 08 Dec 2023 07:01:05 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1702047663; x=1702652463; darn=vger.kernel.org;
        h=to:subject:message-id:date:from:mime-version:from:to:cc:subject
         :date:message-id:reply-to;
        bh=lsDVneHrasqLaAGGoNzdS4KONMuXIYmvuxh8YJJZLTw=;
        b=JE8ud65kv6+RkuutG1iHEWgmDpk+KyDebp38DIghLBCdZgGqwtjfZfjTQ/ON2//TUi
         OYDzzipJFXhY7M5YMKGH0c/1Z6TWhdQilzxinZzICLI6pU3ZDjNt5omUHjrXzBahKjaZ
         zRUGQ8AZb7PhOq3Q5WXIDHPf8+529pZ/duUIoatLT7H6E/8HiotJR1BcslbPCaVTN/at
         xLHs5wkPUKr+OupFKVeAj6VYZ4sgL3ccpOY0IhN36U+WqNaiBBwRSrBNeH7hl4cPB4sf
         DH4Wt6F8G2ess88nlwwHfw0P7pbgTbXxZbChizx+ZWLGBNeAluWq7BSLNwOoI/fyfZyH
         H75A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1702047663; x=1702652463;
        h=to:subject:message-id:date:from:mime-version:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=lsDVneHrasqLaAGGoNzdS4KONMuXIYmvuxh8YJJZLTw=;
        b=qlv38P4pxZemu6VHTiAUpQX59FrTC/OODmKXCPgRo1zPLWZLYMaL+R6n5Tq7xpRquG
         26WucyGwAFmjY+CcO0ldhnlKSMOa/BpFDD+FHwlGsXB9L1/E5bckWwEcTEu4btHofqw0
         wXMpE23MzvkrPwBMxtZcbtwencGRi1DCMD12q25cHQn8+oswaUoc8ot76KVZrY+klnZl
         Xfg9hMcHS1nv08FyHnai9XTpI5L/1O+n1blXqGpBGv17xXCULmJlMq+JD+a2teQhJ1BN
         2L7e9RXSqCZbvev3Bj+G/fTHhxQ+XOMm2mSEIGFeECPqp1HS3lwFRhCKRERnsu3jMj99
         CMhQ==
X-Gm-Message-State: AOJu0YyHHdUF4siXZScJ3MR3EaHmAj8VYxVCdpDSITtHx1zqNPrNfva/
	8l1OaALWyhJFlvNBnB7wMzRjb22k2DMlaLIfX/h4kKZWcis=
X-Google-Smtp-Source: AGHT+IE61FOX6719nbqfYUDS5ScQRR9yCzgyPUnvklxKHLg2IVVUfsDTTN1T7bmmPCJAp2c/nOnH/RkXG027bwDHXUs=
X-Received: by 2002:a50:8e0d:0:b0:54b:67a7:efe5 with SMTP id
 13-20020a508e0d000000b0054b67a7efe5mr76817edw.1.1702047662839; Fri, 08 Dec
 2023 07:01:02 -0800 (PST)
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
From: Gandalf Corvotempesta <gandalf.corvotempesta@gmail.com>
Date: Fri, 8 Dec 2023 16:00:51 +0100
Message-ID: <CAJH6TXiDN2nUzCem5bcYf=kbbcQjhzxwAmP1JQZBD0TnQb9cfg@mail.gmail.com>
Subject: Project quota, info and advices
To: linux-xfs@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"

Hi all
for two new mail server and web server (different machines) i'm
planning to use XFS project
quotas to limit how much space each user could use.

They are all virtual users so i can't rely on user quota and i was
thinking to use project quota with directory-based settings.

In example:

/var/mail/domain1.tld 1GB
/var/mail/domain2.tld 500MB

/var/mail is the XFS filesystem

Some questions:
1. are the usage of config files and numerical IDs mandatory ? Because
i'm fetching config from a db and I prefere to not mess with ID.
2. i've seen that if I remove the directory /var/mail/domain1.tld, the
related project is still showing in the quota report, but if I
recreate the directory, the quota is not honored anymore.
3. how can I delete a single project if not needed anymore?
4. can I use multiple quotas for the same path, in example
/domain1.tld 1GB, /domain1.tld/mailbox1 500MB /domain1.tld/mailbox2
500MB (allowing, in example, 2 different mailboxes, 500MB each and
still 1GB from the parent direcory)

Any better suggestions ?
