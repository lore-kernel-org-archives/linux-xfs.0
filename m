Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="lHoRQjmZ"
Received: from bombadil.infradead.org (bombadil.infradead.org [IPv6:2607:7c80:54:3::133])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3A34D1710;
	Fri,  8 Dec 2023 16:57:40 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Sender:In-Reply-To:Content-Type:
	MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=TzNsX1k4XNEbQ9ZRRD3g6droeKjVaQ/TDmvsq3ojPao=; b=lHoRQjmZZRQC7Ya+2xbHnLd1WG
	ebJgy6T0CWBJ5EDFQrvZFGbkVqCLeZc9O+jo4HhBdKY9bDryNKKerJPW8oilZ+Y/qwpV+Z7FZyEXP
	mgtbUW3R+3DrF8DIiaFPpbJ2N6KTnkZqEBYmZoSb7U2FlN//eWbWEOy+HivMe5DEssJBc6T1CIvnT
	RtA6Ni7ug2D/0eCHZsHz9/hSvIY7LY650dQsXYOD9plkzbWzcyyNhW7LfC40NLyj8RfSGy8DPyS/Y
	MAaol4QGi4oFDXsnZK3BJJyBXjjFFuMfXV4r5wNMXouYLebsZ/L7sS+H6aYace7vch42d0BLoB6fB
	mTFtF+Sg==;
Received: from mcgrof by bombadil.infradead.org with local (Exim 4.96 #2 (Red Hat Linux))
	id 1rBlf0-00Gqfe-03;
	Sat, 09 Dec 2023 00:57:38 +0000
Date: Fri, 8 Dec 2023 16:57:37 -0800
From: Luis Chamberlain <mcgrof@kernel.org>
To: Dave Chinner <david@fromorbit.com>
Cc: Zorro Lang <zlang@redhat.com>, linux-xfs@vger.kernel.org,
	linux-s390@vger.kernel.org, fstests@vger.kernel.org,
	Pankaj Raghav <p.raghav@samsung.com>,
	Daniel Gomez <da.gomez@samsung.com>
Subject: Re: [Bug report] More xfs courruption issue found on s390x
Message-ID: <ZXO7gd3Ft1di8Okm@bombadil.infradead.org>
References: <20231029043333.v6wkqsorxdk2dbch@dell-per750-06-vm-08.rhts.eng.pek2.redhat.com>
 <ZUiHBpJTUr3G4//q@dread.disaster.area>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ZUiHBpJTUr3G4//q@dread.disaster.area>
Sender: Luis Chamberlain <mcgrof@infradead.org>

On Mon, Nov 06, 2023 at 05:26:14PM +1100, Dave Chinner wrote:
> >   XFS: Assertion failed: ip->i_nblocks == 0, file: fs/xfs/xfs_inode.c, line: 2359
>
> IOWs, all four of these issues are the same problem - journal
> recovery is not resulting in a correct and consistent filesystem
> after the journal has been flushed at runtime, so please discuss and
> consolidate them all in the initial bug report thread....

As recently reported, fortunately we now have reproducers for x86_64 too:

https://bugzilla.kernel.org/show_bug.cgi?id=218224

This fails on the following test sections as defined by kdevops [1]:

  * xfs_nocrc_2k
  * xfs_reflink
  * xfs_reflink_1024
  * xfs_reflink_2k
  * xfs_reflink_4k
  * xfs_reflink_dir_bsize_8k
  * xfs_reflink_logdev
  * xfs_reflink_normapbt
  * xfs_reflink_nrext64

[0] https://github.com/linux-kdevops/kdevops/blob/master/playbooks/roles/fstests/templates/xfs/xfs.config

Example failures:

  * generic/475: https://gist.github.com/mcgrof/5d6f504f4695ba27cea7df5d63f35197
  * generic/388: https://gist.github.com/mcgrof/c1c8b1dc76fdc1032a5f0aab6c2a14bf
  * generic/648: https://gist.github.com/mcgrof/1e506ecbe898b45428d6e7febfc02db1

  Luis
