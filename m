Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 79DBB13C820
	for <linux-xfs@vger.kernel.org>; Mon, 15 Jul 2024 22:42:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1721083338; cv=none; b=Nm/DVnD8omaIpJaN6DEdjI3QO2ckotvD5c/LlU5LKFncl1bi7p5AqSAtN2KjFjsbIgTyaZir/nMtLeOFTRdjgbr0+7XL7NDwNV2mT5w1SvJ+OGJEhNGSaRf9RVdAcgpEdgAUHye8VXYqgbDBFPurdVyXY+N3mlPKK7XHFk5n/Sc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1721083338; c=relaxed/simple;
	bh=x+0mIrEXYl6XXHk32G5vc6Ooz6WkoDav3cS/vob7Fjg=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=rPQ/tbpO1Jm/2SdvhvoTPTEZeKozlvnA2ICPA/15btnesEZRU2BCZVLdA9kjP5CukHSbPtKvwc2IjNuYSZ+JBoYhGZvlWaP0kwFp+kejNf+oXUgJtdxTvjUu7uL/7NE1iP1MShIpy8FO8aZIZ+6Gfr02Nd9Fa2LLAt8vnYMiNck=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=fjGz3YtC; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="fjGz3YtC"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0613BC32782;
	Mon, 15 Jul 2024 22:42:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1721083338;
	bh=x+0mIrEXYl6XXHk32G5vc6Ooz6WkoDav3cS/vob7Fjg=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=fjGz3YtCUd/G8bsIG7OowlzYPvan+4RYM4o6TVFuWyqRIODjXo3p1PVjE20T08in6
	 uV+nLJojceUFQ0QKEo3SahunjDuP+Cq2QUjFsXsRyBBJxMxTugh75yyU7sW+Wjnix8
	 w1cgDlWiXkCFyuMGgZssuhq45lN1ZiJsG0VNiXLb8vkQYpy/pN0EFMF4HAUAbeBBkP
	 sMFZyinnex5cJKE3kU2yyoWGGX23+EyhCHrzz9Cw4KHfHlY7xeF5ybnwe3JvsDoNXY
	 sPMEZqCqJRrAhjR6g/NMk7x/qHWZe1+j6dRtoz38q9G0STwxxysZy9jEJt73O5T0Py
	 BYrzFmhBzgo/A==
Date: Mon, 15 Jul 2024 15:42:17 -0700
From: "Darrick J. Wong" <djwong@kernel.org>
To: Wengang Wang <wen.gang.wang@oracle.com>
Cc: "linux-xfs@vger.kernel.org" <linux-xfs@vger.kernel.org>
Subject: Re: [PATCH 3/9] spaceman/defrag: defrag segments
Message-ID: <20240715224217.GX612460@frogsfrogsfrogs>
References: <20240709191028.2329-1-wen.gang.wang@oracle.com>
 <20240709191028.2329-4-wen.gang.wang@oracle.com>
 <20240709215721.GA612460@frogsfrogsfrogs>
 <88831781-0D65-4966-8E95-F429178C9A79@oracle.com>
 <8700A82B-0A70-4C04-B6DE-00F759759C05@oracle.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <8700A82B-0A70-4C04-B6DE-00F759759C05@oracle.com>

On Fri, Jul 12, 2024 at 07:07:01PM +0000, Wengang Wang wrote:
> 
> 
> > On Jul 11, 2024, at 3:49 PM, Wengang Wang <wen.gang.wang@oracle.com> wrote:
> > 
> > 
> > 
> >> On Jul 9, 2024, at 2:57 PM, Darrick J. Wong <djwong@kernel.org> wrote:
> >> 
> >> On Tue, Jul 09, 2024 at 12:10:22PM -0700, Wengang Wang wrote:
> >>> For each segment, the following steps are done trying to defrag it:
> >>> 
> >>> 1. share the segment with a temporary file
> >>> 2. unshare the segment in the target file. kernel simulates Cow on the whole
> >>>  segment complete the unshare (defrag).
> >>> 3. release blocks from the tempoary file.
> >>> 
> >>> Signed-off-by: Wengang Wang <wen.gang.wang@oracle.com>
> >>> ---
> >>> spaceman/defrag.c | 114 ++++++++++++++++++++++++++++++++++++++++++++++
> >>> 1 file changed, 114 insertions(+)
> >>> 
> >>> diff --git a/spaceman/defrag.c b/spaceman/defrag.c
> >>> index 175cf461..9f11e36b 100644
> >>> --- a/spaceman/defrag.c
> >>> +++ b/spaceman/defrag.c

<snip>

> >>> @@ -322,6 +363,79 @@ defrag_xfs_defrag(char *file_path) {
> >>> ret = 1;
> >>> break;
> >>> }
> >>> +
> >>> + /* we are done if the segment contains only 1 extent */
> >>> + if (segment.ds_nr < 2)
> >>> + continue;
> >>> +
> >>> + /* to bytes */
> >>> + seg_off = segment.ds_offset * 512;
> >>> + seg_size = segment.ds_length * 512;
> >>> +
> >>> + clone.src_offset = seg_off;
> >>> + clone.src_length = seg_size;
> >>> + clone.dest_offset = seg_off;
> >>> +
> >>> + /* checks for EoF and fix up clone */
> >>> + stop = defrag_clone_eof(&clone);
> >>> + gettimeofday(&t_clone, NULL);
> >>> + ret = ioctl(scratch_fd, FICLONERANGE, &clone);
> >> 
> >> Hm, should the top-level defrag_f function check in the
> >> filetable[i].fsgeom structure that the fs supports reflink?
> > 
> > Yes, good to know.
> 
> It seems that xfs_fsop_geom doesn’t know about reflink?

XFS_FSOP_GEOM_FLAGS_REFLINK ?

--D

> Thanks,
> Wengang 
> 
> > 
> >> 
> >>> + if (ret != 0) {
> >>> + fprintf(stderr, "FICLONERANGE failed %s\n",
> >>> + strerror(errno));
> >> 
> >> Might be useful to include the file_path in the error message:
> >> 
> >> /opt/a: FICLONERANGE failed Software caused connection abort
> >> 
> >> (maybe also put a semicolon before the strerror message?)
> > 
> > OK.
> > 
> >> 
> >>> + break;
> >>> + }
> >>> +
> >>> + /* for time stats */
> >>> + time_delta = get_time_delta_us(&t_clone, &t_unshare);
> >>> + if (time_delta > max_clone_us)
> >>> + max_clone_us = time_delta;
> >>> +
> >>> + /* for defrag stats */
> >>> + nr_ext_defrag += segment.ds_nr;
> >>> +
> >>> + /*
> >>> +  * For the shared range to be unshared via a copy-on-write
> >>> +  * operation in the file to be defragged. This causes the
> >>> +  * file needing to be defragged to have new extents allocated
> >>> +  * and the data to be copied over and written out.
> >>> +  */
> >>> + ret = fallocate(defrag_fd, FALLOC_FL_UNSHARE_RANGE, seg_off,
> >>> + seg_size);
> >>> + if (ret != 0) {
> >>> + fprintf(stderr, "UNSHARE_RANGE failed %s\n",
> >>> + strerror(errno));
> >>> + break;
> >>> + }
> >>> +
> >>> + /* for time stats */
> >>> + time_delta = get_time_delta_us(&t_unshare, &t_punch_hole);
> >>> + if (time_delta > max_unshare_us)
> >>> + max_unshare_us = time_delta;
> >>> +
> >>> + /*
> >>> +  * Punch out the original extents we shared to the
> >>> +  * scratch file so they are returned to free space.
> >>> +  */
> >>> + ret = fallocate(scratch_fd,
> >>> + FALLOC_FL_PUNCH_HOLE|FALLOC_FL_KEEP_SIZE, seg_off,
> >>> + seg_size);
> >> 
> >> Indentation here (two tabs for a continuation).  
> > 
> > OK.
> > 
> >> Or just ftruncate
> >> scratch_fd to zero bytes?  I think you have to do that for the EOF stuff
> >> to work, right?
> >> 
> > 
> > I’d truncate the UNSHARE range only in the loop.
> > EOF stuff would be truncated on (O_TMPFILE) file close.
> > The EOF stuff would be used for another purpose, see 
> > [PATCH 6/9] spaceman/defrag: workaround kernel
> > 
> > Thanks,
> > Wengang
> > 
> >> --D
> >> 
> >>> + if (ret != 0) {
> >>> + fprintf(stderr, "PUNCH_HOLE failed %s\n",
> >>> + strerror(errno));
> >>> + break;
> >>> + }
> >>> +
> >>> + /* for defrag stats */
> >>> + nr_seg_defrag += 1;
> >>> +
> >>> + /* for time stats */
> >>> + time_delta = get_time_delta_us(&t_punch_hole, &t_clone);
> >>> + if (time_delta > max_punch_us)
> >>> + max_punch_us = time_delta;
> >>> +
> >>> + if (stop)
> >>> + break;
> >>> } while (true);
> >>> out:
> >>> if (scratch_fd != -1) {
> >>> -- 
> >>> 2.39.3 (Apple Git-146)
> 
> 
