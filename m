Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 4C3D97F67
	for <xfs@oss.sgi.com>; Tue,  6 Jan 2015 23:49:01 -0600 (CST)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 2A1BB8F8035
	for <xfs@oss.sgi.com>; Tue,  6 Jan 2015 21:49:01 -0800 (PST)
Received: from mailout1.samsung.com (mailout1.samsung.com [203.254.224.24]) by
	cuda.sgi.com with ESMTP id CRzf6FXqhl382nSa (version=TLSv1
	cipher=RC4-MD5 bits=128 verify=NO) for <xfs@oss.sgi.com>;
	Tue, 06 Jan 2015 21:48:59 -0800 (PST)
Received: from epcpsbgr4.samsung.com
	(u144.gpu120.samsung.co.kr [203.254.230.144])
	by mailout1.samsung.com (Oracle Communications Messaging Server
	7u4-24.01 (7.0.4.24.0) 64bit (built Nov 17 2011))
	with ESMTP id <0NHS00DCKLHM9WE0@mailout1.samsung.com> for
	xfs@oss.sgi.com; Wed, 07 Jan 2015 14:48:58 +0900 (KST)
From: Namjae Jeon <namjae.jeon@samsung.com>
References: <004901d02670$835ac120$8a104360$@samsung.com>
	<20150106181323.GI5874@bfoster.bfoster>
In-reply-to: <20150106181323.GI5874@bfoster.bfoster>
Subject: RE: [PATCH v7 11/11] xfstests: fsx: Add fallocate insert range
	operation
Date: Wed, 07 Jan 2015 14:48:57 +0900
Message-id: <001901d02a3d$a10cd9d0$e3268d70$@samsung.com>
MIME-version: 1.0
Content-language: ko
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
To: 'Brian Foster' <bfoster@redhat.com>
Cc: 'Theodore Ts'o' <tytso@mit.edu>, linux-kernel@vger.kernel.org, xfs@oss.sgi.com, 'Ashish Sangwan' <a.sangwan@samsung.com>, linux-fsdevel@vger.kernel.org, 'linux-ext4' <linux-ext4@vger.kernel.org>

> >  		}
> >  		break;
> > +	case OP_INSERT_RANGE:
> > +		if (!insert_range_calls) {
> > +			log4(OP_SKIPPED, OP_INSERT_RANGE, offset, size);
> > +			goto out;
> > +		}
> > +		break;
> >  	}
> >
> >  	switch (op) {
> > @@ -1244,6 +1313,21 @@ test(void)
> >  		}
> >  		do_collapse_range(offset, size);
> >  		break;
> > +	case OP_INSERT_RANGE:
> > +		TRIM_OFF_LEN(offset, size, (maxfilelen - 1) - file_size);
> 
> I see a ton of "skipping insert beyond EOF" messages when I run fsx with
> this patch that boil down to that we trim against the max allowable file
> size increase rather than the current file size. I suspect the intent
> here is to not limit the insert length based on the file size. That
> makes sense, but that causes us to fail to mod the insert offset against
> the file size and thus generate a ton more noise.
> 
> Could we either open code the trim to handle the offset/len correctly or
> break up the macro in a way that facilitates doing so? For example, a
> quick solution might be to create TRIM_OFF() and TRIM_LEN() based on the
> associated code in TRIM_OFF_LEN(), redefine TRIM_OFF_LEN() to use the
> new macros, and then the insert range code could do something like:
> 
> 	TRIM_OFF(offset, file_size - 1);
> 	TRIM_LEN(offset, size, maxfilelen - file_size);
> 	...
> 
Okay, I will change it as your suggestion.

> Brian
> 

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
