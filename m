Authentication-Results: smtp.subspace.kernel.org; dkim=none
Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BB1F11B8
	for <linux-xfs@vger.kernel.org>; Mon, 27 Nov 2023 21:32:21 -0800 (PST)
Received: by verein.lst.de (Postfix, from userid 2407)
	id 3440567373; Tue, 28 Nov 2023 06:32:19 +0100 (CET)
Date: Tue, 28 Nov 2023 06:32:19 +0100
From: Christoph Hellwig <hch@lst.de>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: Christoph Hellwig <hch@lst.de>,
	Chandan Babu R <chandan.babu@oracle.com>, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 3/4] xfs: clean up the xfs_reserve_blocks interface
Message-ID: <20231128053219.GB16579@lst.de>
References: <20231126130124.1251467-1-hch@lst.de> <20231126130124.1251467-4-hch@lst.de> <20231128020933.GS2766956@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20231128020933.GS2766956@frogsfrogsfrogs>
User-Agent: Mutt/1.5.17 (2007-11-01)

On Mon, Nov 27, 2023 at 06:09:33PM -0800, Darrick J. Wong wrote:
> > +	spin_lock(&mp->m_sb_lock);
> > +	fsop.resblks = mp->m_resblks;
> > +	fsop.resblks_avail = mp->m_resblks_avail;
> > +	spin_unlock(&mp->m_sb_lock);
> 
> Hm.  I sorta preferred keeping these details hidden in xfs_fsops.c
> rather than scattering them around and lengthening xfs_ioctl.c, but
> I think the calling convention cleanup is worthy enough for:

If you prefer I can keep a helper to fill in a xfs_fsop_resblks
structure under m_sb_lock in fsops.c, but I'm not sure that's worth it.

