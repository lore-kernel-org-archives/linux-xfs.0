Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="FtF77hqK"
Received: from bombadil.infradead.org (bombadil.infradead.org [IPv6:2607:7c80:54:3::133])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CE4BD116;
	Tue, 12 Dec 2023 05:10:44 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=ahu4/U/soh/dA2Q7HSesGB7diJShIHO31XJcJ7WvGa8=; b=FtF77hqKG+5XA3T32JPw3/a4U5
	5OvUv+ihcFuSlPlYbDcAJN4l/kk8He7gPEnLATDEXa94mGS7Hg6HsAKEH2bJHeKsi19Q43/BIpQgc
	FwLRjTaHAkQXDmrZsJzmJkoB/lLM0rK7ouD6cdn1xn85GlqoFCYew1QokfjDkr7AwU6QCj2Pyfcqz
	uDujeYaNmJCfAiKS2TZsN6TqB3Po2wtDOzznyMBwTiwNuATrv5LKcS8wdUDfXZKNf2UcwDsw0D7gb
	5kdg8EavFa+GSus987vBL5vuklPWFxFp6ChjB2MfY+rQvbvrl5AJdsIlokYV4sFSh1VZ/Spcb4+Zb
	sRrIYS6Q==;
Received: from hch by bombadil.infradead.org with local (Exim 4.96 #2 (Red Hat Linux))
	id 1rD2X4-00BlAA-2C;
	Tue, 12 Dec 2023 13:10:42 +0000
Date: Tue, 12 Dec 2023 05:10:42 -0800
From: Christoph Hellwig <hch@infradead.org>
To: John Garry <john.g.garry@oracle.com>
Cc: Ojaswin Mujoo <ojaswin@linux.ibm.com>, linux-ext4@vger.kernel.org,
	Theodore Ts'o <tytso@mit.edu>,
	Ritesh Harjani <ritesh.list@gmail.com>,
	linux-kernel@vger.kernel.org,
	"Darrick J . Wong" <djwong@kernel.org>, linux-block@vger.kernel.org,
	linux-xfs@vger.kernel.org, linux-fsdevel@vger.kernel.org,
	dchinner@redhat.com
Subject: Re: [RFC 0/7] ext4: Allocator changes for atomic write support with
 DIO
Message-ID: <ZXhb0tKFvAge/GWf@infradead.org>
References: <cover.1701339358.git.ojaswin@linux.ibm.com>
 <8c06c139-f994-442b-925e-e177ef2c5adb@oracle.com>
 <ZW3WZ6prrdsPc55Z@li-bb2b2a4c-3307-11b2-a85c-8fa5c3a69313.ibm.com>
 <de90e79b-83f2-428f-bac6-0754708aa4a8@oracle.com>
 <ZXbqVs0TdoDcJ352@li-bb2b2a4c-3307-11b2-a85c-8fa5c3a69313.ibm.com>
 <c4cf3924-f67d-4f04-8460-054dbad70b93@oracle.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <c4cf3924-f67d-4f04-8460-054dbad70b93@oracle.com>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

On Tue, Dec 12, 2023 at 07:46:51AM +0000, John Garry wrote:
> It is assumed that the user will fallocate/dd the complete file before
> issuing atomic writes, and we will have extent alignment and length as
> required.

I don't think that's a long time maintainable usage model.
