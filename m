Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 62E19800D
	for <xfs@oss.sgi.com>; Mon, 29 Sep 2014 15:17:19 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 38F2C8F8033
	for <xfs@oss.sgi.com>; Mon, 29 Sep 2014 13:17:16 -0700 (PDT)
Date: Mon, 29 Sep 2014 16:16:50 -0400
Subject: Re: [RFC v2] Unicode/UTF-8 support for XFS
Message-ID: <20140929201650.GA3640@fieldses.org>
References: <20140918195650.GI19952@sgi.com> <20140922222611.GZ4322@dastard>
	<5422C540.1060007@sgi.com> <20140924231024.GA4758@dastard>
	<54257D3F.70302@sgi.com> <20140926165605.GA25274@infradead.org>
	<20140926170407.GB6012@samba2> <5425C067.7080904@sgi.com>
	<20140926194656.GC13066@samba2> <5425C6A6.3060003@sgi.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <5425C6A6.3060003@sgi.com>
From: "J. Bruce Fields" <bfields@fieldses.org>
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
To: Olaf Weber <olaf@sgi.com>
Cc: tinguely@sgi.com, xfs@oss.sgi.com, Christoph Hellwig <hch@infradead.org>, Ben Myers <bpm@sgi.com>, linux-fsdevel@vger.kernel.org, Jeremy Allison <jra@samba.org>

On Fri, Sep 26, 2014 at 10:03:50PM +0200, Olaf Weber wrote:
> On 26-09-14 21:46, Jeremy Allison wrote:
> >On Fri, Sep 26, 2014 at 09:37:11PM +0200, Olaf Weber wrote:
> >>
> >>My argument against "mount time case-insensitivity" and for "mkfs
> >>time case-insensitivity" is related to switching from the
> >>case-sensitive domain to the case-insensitive one.
> >>
> >>For case-sensitive, from "README" to "readme" there are 64 different
> >>possible filenames.  Let's say you create 63 out of these 64. Now
> >>remount the filesystem case-insensitive, and try to open by the 64th
> >>version of "readme". It is not an exact match for any of the 63
> >>candidate files, and a case-insensitive match to all 63 candidate
> >>files. Which of these 63 files should be opened, and why that one in
> >>particular?
> >
> >I'm ok with "mkfs time case-insensitivity" - really !
> >Most of my OEMs would set that and claim victory (few
> >of them care much about NFS semantics :-).
> 
> I'd say you can have CIFS-style case-insensitive semantics or
> NFS-style case-sensitive semantics, but not both.

Note the NFSv4 specs do claim to allow case insensitivity.  No idea how
well clients deal with it.

I think rfc3530bis has the most up to date language on NFSv4
internationalization issues:

	http://tools.ietf.org/html/draft-ietf-nfsv4-rfc3530bis-33

(One nit in the current knfsd: the server doesn't correctly report the
case_insensitive attribute.  If it had some flag it could check in the
filesystem's superblock then it could do that right instead of just
assuming 0 as it currently does (see FATTR4_WORD0_CASE_INSENSITIVE in
fs/nfsd/nfs4xdr.c:nfsd4_encode_fattr).)

--b.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
