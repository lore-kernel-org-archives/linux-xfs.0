Received: from mail-ed1-f53.google.com (mail-ed1-f53.google.com [209.85.208.53])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D7A6837AA6E
	for <linux-xfs@vger.kernel.org>; Thu, 22 Jan 2026 20:07:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.208.53
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769112467; cv=pass; b=s9V+rdAc310deH2EuaSx5mW5c7QnYc+83K0VlfRx1lM9l1YIhlwJg8PROQzRLhwzzV/xn0lvlLsdT/IAN8lJmvkBzit1EysinUzlKnIPVIhlxu4I9N+EyxVExXbigpWWS7+WPRXkHLHwUgKOdEbHhCSp+UtuBu04r0QGuDEtGe0=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769112467; c=relaxed/simple;
	bh=UeToXNeIZz9y9OvrlDazfYnO7oODJgQv05/I8arOeUU=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=GoIOtPDNMHGMh9Y2iWLc2FIgDD0OlPWQQRHXLywIr/FjQo5WjBWB2e3Lzhsx1OguICc6UTk3WC3z+abNfnqaQhFPGL4P6znrFFpU+Zh48B53l9DkOMkwqqDhXwPJegugwoAZz8s2iloyVY6nJKczqlqxDTQJ+41q41RcY4xxhQo=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=X/lWqrLz; arc=pass smtp.client-ip=209.85.208.53
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="X/lWqrLz"
Received: by mail-ed1-f53.google.com with SMTP id 4fb4d7f45d1cf-65808bb859cso2402639a12.2
        for <linux-xfs@vger.kernel.org>; Thu, 22 Jan 2026 12:07:43 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1769112459; cv=none;
        d=google.com; s=arc-20240605;
        b=WJWeyYKxmKBfUUwSOPn7yHqkDPHHnHSdvs9lB3YbMvVFK4/usTrL79ug+59tiwpnEE
         L83V1QXCK/rtlpM07H/J+NwOCtlj0tyW2h85Le9opF8GIj3VQ26q1qpZpbEm5Lwem9de
         8LMWOMm0MvqOhhlwZiteNzx+NEcKEc4sOjByBs98axU4ESpHiQWI5PQROJZM5EKQBigb
         Vnj523RUPgSL4bNohjBt6ZBf0CzlrR8GGBvOdYHiAT8sbDYqMGA50xpAzczYiMjOkwDD
         332SLODTHSnLctLXM7xzibiaUBSUUdpoGnaP0k42j4Hhc8CqVNPjO39Qmc/d4mHhMu/v
         3AWw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=UeToXNeIZz9y9OvrlDazfYnO7oODJgQv05/I8arOeUU=;
        fh=R70DAMX4GkqpOTDaDm5c0zbZBhJDzvs50KefEN/gZVE=;
        b=hbkrcABalR1rzDIIKiagPnNIiea7K2vG6z9H9nvKDo0o8ibjWBZMdN9rtPU+0HSivu
         vVquEFkRJ6DBsKenFgpsewXOFpfMjDI1/WooLOLaPctthW9MHXBk9Lh1vkk+bTZRLMM7
         Nx6yvUmdcGkvXh5LtQw+4kc3n8Qw2emGn5rZL8680/J2U+/ad5PxDP0FUlDALxZ1CGHS
         PgYXqMSEZRQCLQnJgBrfJReWib1/uIajQa+TDuTzvDksfSdlOtuDU4t4Ge7KVHrdmoJ7
         dbm1PMcHBDzweXIxMxmzMmN7FWLHpIHLtq/6tZe6lRxQwtfWHcoIzK9//Pdknbbrowrr
         KmnA==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1769112459; x=1769717259; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=UeToXNeIZz9y9OvrlDazfYnO7oODJgQv05/I8arOeUU=;
        b=X/lWqrLz2bQ6qvlxMp7/4e7A3KNMkcvHPGvJrXvIoIFpAaXIC/J52gb0mTswrvGFCP
         qSSVd1czapsgBn9o4IwsRwvrzkDyZFQx/Q7wv1QR4ekmsTMySm+kz1F5NgHYxohKdeQW
         9UBy+879Kpi1tgCxNhjuYt8DS45VfiBkOyHJO/2HCOK97WnN26k3ENKaWBrgHO+JG8UL
         BEq6qWIJt7oQcNqg684IBIHDoze+DmC0pRYl6PWRXWVulbGGtM+GXeZOX3icPwGLoZvy
         F8yBwJU6ABDv/T7C8paHIdvH8dD98D8xBTj2IE6kxogY0Puri6AgRf99EEFaozcudOgy
         Dzog==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1769112459; x=1769717259;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=UeToXNeIZz9y9OvrlDazfYnO7oODJgQv05/I8arOeUU=;
        b=F3K8rvj6T9c0mqw1VOYf+eWqNP9aN8A5lBI+8mJGG8TXb7umtYEsAQfXeQ8H31KOPX
         gsPkX4QConWjv0ii07dgCyTzWNI1Aeh8y/vM4XUvRVacTKqxjnY3kPZClu3VVY8Er7CM
         Qvqt/Q9sddQhQNWAcfEpAwzxSqKjsgvDRRFpoA2zJGtp0BzVK1+SVUqmbdy65YXDcQvc
         Hfon3+pS4n6VoP20oUKyMZZn2uLUWzOEcI8Q1yuHJPEvkBhSnxUkljpcq8WIHyw/P2eI
         xgyPqa8IjbVGSTb0ecPKt+VVN0Kg3YxfOGgd2svH1KKc2RZpmP/ZbymOFPMXL3PiINjY
         EClA==
X-Forwarded-Encrypted: i=1; AJvYcCU/Zwt3YVebzRzfDqkJ4uwrfaA1nTttjZX/W4jWsSqcwMLL52REDclm5sBhdVVrt9MEn5k2YdLIjRA=@vger.kernel.org
X-Gm-Message-State: AOJu0YzNup2UQwTp7+8/4ljq6LvOyBaYVpYfJ5lIVO+lQ+qlZzTUjpL+
	iobqSmJLcYBI9wXAnmbUgzngIFB32YPj/Q+SwDu/rioqgIXfnLAed3LgOLo18ohLOCrLUFyhvMT
	g+q1kQlDk+APymre6CokDYu0fNtb6ww4=
X-Gm-Gg: AZuq6aIpvXS3v4ytdu+IFwXSGoEY6eLjwLDp0TdCRbTeQiqmy6hFT0qmORAOJWzhGOA
	pSjA9yIdiFTx7KyRUUAUqNXSFlkKcWA37858Ev9HvxY2Ho/ibZZDtNItRECVkXALdjlVUcgSm3x
	b2mogEHH5Fv/sliH39CKP+Oq5HQeB8yFPsIRwEMXhESRUjtwKY9g5Ijo+LymX/97IZBuXB3x8EW
	ADPd1nYFu2XjoYHrqcY9J0vqpkaV+UNT5kFQl3H6DBYteqZIDUQqdnh5vEvgZal/sdQLR2x2J7z
	/zqqtf5aKgBJkp78Am0NeN0fh4ads5/6/3fEVQ6z
X-Received: by 2002:a17:907:70a:b0:b84:42e5:2b7e with SMTP id
 a640c23a62f3a-b885ae682a6mr30056466b.51.1769112458391; Thu, 22 Jan 2026
 12:07:38 -0800 (PST)
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260114-tonyk-get_disk_uuid-v1-0-e6a319e25d57@igalia.com>
 <20260114-tonyk-get_disk_uuid-v1-3-e6a319e25d57@igalia.com>
 <20260114062608.GB10805@lst.de> <5334ebc6-ceee-4262-b477-6b161c5ca704@igalia.com>
 <20260115062944.GA9590@lst.de> <633bb5f3-4582-416c-b8b9-fd1f3b3452ab@suse.com>
 <20260115072311.GA10352@lst.de> <22b16e24-d10e-43f6-bc2b-eeaa94310e3a@igalia.com>
 <CAOQ4uxhbz7=XT=C3R8XqL0K_o7KwLKsoNwgk=qJGuw2375MTJw@mail.gmail.com>
 <0241e2c4-bf11-4372-9eda-cccaba4a6d7d@igalia.com> <CAOQ4uxi988PutUi=Owm5zf6NaCm90PUCJLu7dw8firH8305w-A@mail.gmail.com>
 <33c1ccbd-abbe-4278-8ab1-d7d645c8b6e8@igalia.com> <CAOQ4uxgCM=q29Vs+35y-2K9k7GP2A2NfPkuqCrUiMUHW+KhbWw@mail.gmail.com>
 <75a9247a-12f4-4066-9712-c70ab41c274f@igalia.com> <CAOQ4uxig==FAd=2hO0B_CVBDSuBwdqL-zaXkpf-QXn5iEL364g@mail.gmail.com>
In-Reply-To: <CAOQ4uxig==FAd=2hO0B_CVBDSuBwdqL-zaXkpf-QXn5iEL364g@mail.gmail.com>
From: Amir Goldstein <amir73il@gmail.com>
Date: Thu, 22 Jan 2026 21:07:27 +0100
X-Gm-Features: AZwV_Qj-Pre4XZbhvcFXr13YDWLuhkhhzBZFRQumTLtcoMVU1rOesRZLphknff4
Message-ID: <CAOQ4uxg6dKr4XB3yAkfGd_ehZkBMcoNHiF5CeB9=3aca44yHRg@mail.gmail.com>
Subject: Re: [PATCH 3/3] ovl: Use real disk UUID for origin file handles
To: =?UTF-8?Q?Andr=C3=A9_Almeida?= <andrealmeid@igalia.com>
Cc: Christoph Hellwig <hch@lst.de>, Chuck Lever <chuck.lever@oracle.com>, Jeff Layton <jlayton@kernel.org>, 
	NeilBrown <neil@brown.name>, Olga Kornievskaia <okorniev@redhat.com>, Dai Ngo <Dai.Ngo@oracle.com>, 
	Tom Talpey <tom@talpey.com>, Carlos Maiolino <cem@kernel.org>, Chris Mason <clm@fb.com>, 
	David Sterba <dsterba@suse.com>, Miklos Szeredi <miklos@szeredi.hu>, 
	Christian Brauner <brauner@kernel.org>, Alexander Viro <viro@zeniv.linux.org.uk>, Jan Kara <jack@suse.cz>, 
	linux-nfs@vger.kernel.org, linux-kernel@vger.kernel.org, 
	linux-xfs@vger.kernel.org, linux-fsdevel@vger.kernel.org, 
	Qu Wenruo <wqu@suse.com>, linux-btrfs@vger.kernel.org, linux-unionfs@vger.kernel.org, 
	kernel-dev@igalia.com, vivek@collabora.com, 
	Ludovico de Nittis <ludovico.denittis@collabora.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Tue, Jan 20, 2026 at 4:12=E2=80=AFPM Amir Goldstein <amir73il@gmail.com>=
 wrote:
>
> On Mon, Jan 19, 2026 at 5:56=E2=80=AFPM Andr=C3=A9 Almeida <andrealmeid@i=
galia.com> wrote:
> >
...
> > Actually they are not in the same fs, upper and lower are coming from
> > different fs', so when trying to mount I get the fallback to
> > `uuid=3Dnull`. A quick hack circumventing this check makes the mount wo=
rk.
> >
> > If you think this is the best way to solve this issue (rather than
> > following the VFS helper path for instance),
>
> That's up to you if you want to solve the "all lower layers on same fs"
> or want to also allow lower layers on different fs.
> The former could be solved by relaxing the ovl rules.
>
> > please let me know how can
> > I safely lift this restriction, like maybe adding a new flag for this?
>
> I think the attached patch should work for you and should not
> break anything.
>
> It's only sanity tested and will need to write tests to verify it.
>

Andre,

I tested the patch and it looks good on my side.
If you want me to queue this patch for 7.0,
please let me know if it addresses your use case.

Thanks,
Amir.
