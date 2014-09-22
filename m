Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id B66D27F4E
	for <xfs@oss.sgi.com>; Mon, 22 Sep 2014 13:41:48 -0500 (CDT)
Date: Mon, 22 Sep 2014 13:41:45 -0500
From: Ben Myers <bpm@sgi.com>
Subject: Re: [RFC v2] Unicode/UTF-8 support for XFS
Message-ID: <20140922184145.GH4482@sgi.com>
References: <20140918195650.GI19952@sgi.com>
	<87lhpbhfgg.fsf@tassilo.jf.intel.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <87lhpbhfgg.fsf@tassilo.jf.intel.com>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: Andi Kleen <andi@firstfloor.org>
Cc: linux-fsdevel@vger.kernel.org, tinguely@sgi.com, olaf@sgi.com, xfs@oss.sgi.com

Hey Andi,

On Mon, Sep 22, 2014 at 07:55:59AM -0700, Andi Kleen wrote:
> Ben Myers <bpm@sgi.com> writes:
> >
> > Strings are normalized using a trie that stores the relevant
> > information.  The trie itself is about 250kB in size, and lives in a
> > separate module.
> 
> So 250kB bloat -- and what does this fix exactly?

We're trying to address the size issue by only loading the module when
it's needed, but yeah it's big.  Open to suggestions on how best to deal
with that.  I understand the sticker shock.
 
> Someone putting random ligatures into their file names and expecting
> the file to be the same as before. Can't they just not do that?

The ligature example that Olaf gave might seem kind of trivial, but for
other characters and languages could it be more significant?

As far as telling the customer "don't do that", my guess is that they
would just go elsewhere.  There are several other options for
filesystems that support unicode.

Thanks,
	Ben

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
