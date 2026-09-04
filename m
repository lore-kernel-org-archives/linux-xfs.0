Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3F877445AC6;
	Fri,  4 Sep 2026 09:54:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788515696; cv=none; b=D+8EQ88vuSQc623sUNz+6Kn6pGeaEWyAgx8WH6qVk/EQjTG8AivuX/xCiTnJelSyZyBvGevpA086fQkoyE2j6RksEo5bL8iZ/xQQWG14AFu8UZ8JfsoPTez5e5tJ0wZ4iznvkoXpJ0CwCr7sMtCbkZUMWEhSy+7+BgKb3lVLDJk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788515696; c=relaxed/simple;
	bh=eJdBf1rdIxDT5xpJUkFuSybvkBG661dnEGS9ikAwuv0=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=hR4O+DcgtZIDaGL+Hzyzh5AWrrb8xDyAQ0m//2TE7D5VqllfGSkEH1+ItneFzDXN/nDnYuC8Hwg4tDRep2OaDGNwZZ7+M8/3Qgz1PwHvajQT9EaEvbAHdshBWa8JbIs1z0Hc01jRhw7jbJkBNXwPd8w2WnHct005QxvwG4zJEZE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=AYBz7On/; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="AYBz7On/"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 578801F00A3D;
	Fri,  4 Sep 2026 09:54:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788515694;
	bh=s6vbWpY5Z/G7ZlqVuOMJfoiEqYIeiGW1jnFkESRWPQw=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=AYBz7On/UKbMSHwv9pVA4LB8ojOthiXuJxV9KIMV3Y47XYk8NGQWdNvUu2+pBg5on
	 MBGlopAjnUcKYVewLRfzBrYLoiPJwSeyt/doI7klYZqjFSZdSFBuzquq1/6C6az3Il
	 /Z0bvawzV4l/VLSb9Vmv+iO9w1H5ts7eVdQxh6NTA1hcvoPuSDYrJgKE8ZL3yfyeQT
	 +o1KVJgJhmtWjBAwAF5moWjvnQwwWpjbcOL/zUP/pyyMKvSTq0UsNleSIkYNULqdFQ
	 z9yWQ19Qy5i52Zpqi86uT9OA8YBOYGxdHRS4g9T+Dh0sYiHjpw2+1TAgtvAkGn4Kj8
	 Kh/mf9BL3/mfQ==
Date: Fri, 4 Sep 2026 11:54:47 +0200
From: Christian Brauner <brauner@kernel.org>
To: Joanne Koong <joannelkoong@gmail.com>
Cc: hch@lst.de, "Darrick J . Wong" <djwong@kernel.org>, 
	linux-fsdevel@vger.kernel.org, changfengnan@bytedance.com, kbusch@kernel.org, 
	Matthew Wilcox <willy@infradead.org>, Jan Kara <jack@suse.cz>, Jonathan Corbet <corbet@lwn.net>, 
	David Sterba <dsterba@suse.com>, Gao Xiang <xiang@kernel.org>, 
	Namjae Jeon <linkinjeon@kernel.org>, Theodore Ts'o <tytso@mit.edu>, Jaegeuk Kim <jaegeuk@kernel.org>, 
	Miklos Szeredi <miklos@szeredi.hu>, Andreas Gruenbacher <agruenba@redhat.com>, 
	Mikulas Patocka <mikulas@artax.karlin.mff.cuni.cz>, Hyunchul Lee <hyc.lee@gmail.com>, 
	Konstantin Komarov <almaz.alexandrovich@paragon-software.com>, Carlos Maiolino <cem@kernel.org>, 
	Damien Le Moal <dlemoal@kernel.org>, libaokun@linux.alibaba.com, bfoster@redhat.com, 
	linux-ext4@vger.kernel.org, linux-xfs@vger.kernel.org
Subject: Re: (subset) [PATCH v5 00/22] iomap: convert to in-iter iomap_next()
 model
Message-ID: <20260904-setzlinge-hausbank-bewarben-bc80609b311a@brauner>
References: <20260729192737.3190206-1-joannelkoong@gmail.com>
 <20260730-habseligkeiten-adrett-axthieb-e619a48325ad@brauner>
 <20260731-hirte-hacken-atmen-bdecd01097f1@brauner>
 <CAJnrk1aX__NiZs-RE1N1MzDVeCsRt12d_mwX_K7Eq2bHtNfdYA@mail.gmail.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAJnrk1aX__NiZs-RE1N1MzDVeCsRt12d_mwX_K7Eq2bHtNfdYA@mail.gmail.com>

On Wed, Sep 02, 2026 at 10:45:38AM -0700, Joanne Koong wrote:
> On Fri, Jul 31, 2026 at 6:40 AM Christian Brauner <brauner@kernel.org> wrote:
> >
> > > [20/22] iomap: remove ->iomap_begin()/->iomap_end() legacy path
> > >         https://git.kernel.org/vfs/vfs/c/0210c4ba2547
> >
> > That accidently slipped in. I have not dropped this from the v7.3 merge
> > window. I'll get a v7.3-rc1.iomap ready with the last three patches.
> >
> 
> Hi Christian,
> 
> Hope you're having a great week so far. I'm not seeing the last 3
> patches as part of v7.3-rc1. Do you think it would make more sense to
> have it be included in rc2 or to have it be part of v7.4? I'm happy
> with either, just wanted to flag this in case I'm missing something.

No, we can still try and send it for -rc2. I'll pick them up in a
second.
