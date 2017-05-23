Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from sandeen.net ([63.231.237.45]:54402 "EHLO sandeen.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1757843AbdEWPrv (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Tue, 23 May 2017 11:47:51 -0400
Subject: Re: [PATCH] xfs_metadump: tag metadump image with attribute flags
References: <402504cb-1632-85b6-a745-1334ccf0ee8f@redhat.com>
 <20170523154603.GR4519@birch.djwong.org>
From: Eric Sandeen <sandeen@sandeen.net>
Message-ID: <41c04794-5aef-5e2e-17ad-9ccf8aac488c@sandeen.net>
Date: Tue, 23 May 2017 10:47:50 -0500
MIME-Version: 1.0
In-Reply-To: <20170523154603.GR4519@birch.djwong.org>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: "Darrick J. Wong" <darrick.wong@oracle.com>, Eric Sandeen <sandeen@redhat.com>
Cc: linux-xfs <linux-xfs@vger.kernel.org>

On 5/23/17 10:46 AM, Darrick J. Wong wrote:
> On Mon, May 22, 2017 at 07:33:35PM -0500, Eric Sandeen wrote:
>> After the long discussion about warning the user and/or consumer
>> of xfs_metadumps about dirty logs, it crossed my mind that we
>> could use the reserved slot in the metadump header to tag the
>> file with attributes, so the consumer of the metadump knows how
>> it was created.
>>
>> This patch adds 3 flags to describe the metadump: dirty log,
>> obfuscated, and full blocks (unused portions of metadata blocks
>> are not zeroed out).
>>
>> It then adds a new option to xfs_mdrestore, "-i" to show info,
>> which can be used with or without a target file:


>> +/* mb_flags */
>> +#define XFS_METADUMP_OBFUSCATED	(1 << 0)
>> +#define XFS_METADUMP_FULLBLOCKS	(1 << 1)
>> +#define XFS_METADUMP_DIRTYLOG	(1 << 2)
> 
> If we always wrote zero for mb_reserved previously, how do we
> distinguish between a non-obfuscated partial-block clean-log metadump
> and an old metadump?  Do we care?

Oh right.  ;)

> I imagine metadumps are fairly transitory in nature, so it might not be
> a big deal, and probably not worth burning 1/8 of our flag-space over
> since AFAICT we don't use the(se) flags for any serious behavioral
> changes.

OTOH, how many flags would we possibly have?  I'm ok with adding a
"we have flags" flag, too.

-Eric

> --D
> 
>> +
>>  #endif /* _XFS_METADUMP_H_ */
>> diff --git a/man/man8/xfs_mdrestore.8 b/man/man8/xfs_mdrestore.8
>> index 2095f15..10c00b2 100644
>> --- a/man/man8/xfs_mdrestore.8
>> +++ b/man/man8/xfs_mdrestore.8
>> @@ -4,11 +4,15 @@ xfs_mdrestore \- restores an XFS metadump image to a filesystem image
>>  .SH SYNOPSIS
>>  .B xfs_mdrestore
>>  [
>> -.B \-g
>> +.B \-gi
>>  ]
>>  .I source
>>  .I target
>>  .br
>> +.B xfs_mdrestore
>> +.B \-i
>> +.I source
>> +.br
>>  .B xfs_mdrestore \-V
>>  .SH DESCRIPTION
>>  .B xfs_mdrestore
>> @@ -39,6 +43,11 @@ can be destroyed.
>>  .B \-g
>>  Shows restore progress on stdout.
>>  .TP
>> +.B \-i
>> +Shows metadump information on stdout.  If no
>> +.I target
>> +is specified, exits after displaying information.
>> +.TP
>>  .B \-V
>>  Prints the version number and exits.
>>  .SH DIAGNOSTICS
>> diff --git a/mdrestore/xfs_mdrestore.c b/mdrestore/xfs_mdrestore.c
>> index 0d399f1..1fbb1e6 100644
>> --- a/mdrestore/xfs_mdrestore.c
>> +++ b/mdrestore/xfs_mdrestore.c
>> @@ -21,6 +21,7 @@
>>  
>>  char 		*progname;
>>  int		show_progress = 0;
>> +int		show_info = 0;
>>  int		progress_since_warning = 0;
>>  
>>  static void
>> @@ -213,11 +214,14 @@ main(
>>  
>>  	progname = basename(argv[0]);
>>  
>> -	while ((c = getopt(argc, argv, "gV")) != EOF) {
>> +	while ((c = getopt(argc, argv, "giV")) != EOF) {
>>  		switch (c) {
>>  			case 'g':
>>  				show_progress = 1;
>>  				break;
>> +			case 'i':
>> +				show_info = 1;
>> +				break;
>>  			case 'V':
>>  				printf("%s version %s\n", progname, VERSION);
>>  				exit(0);
>> @@ -226,7 +230,11 @@ main(
>>  		}
>>  	}
>>  
>> -	if (argc - optind != 2)
>> +	if (argc - optind < 1 || argc - optind > 2)
>> +		usage();
>> +
>> +	/* show_info without a target is ok */
>> +	if (!show_info && argc - optind != 2)
>>  		usage();
>>  
>>  	/* open source */
>> @@ -239,6 +247,29 @@ main(
>>  		if (src_f == NULL)
>>  			fatal("cannot open source dump file\n");
>>  	}
>> +
>> +	if (show_info) {
>> +		xfs_metablock_t		mb;
>> +
>> +		if (fread(&mb, sizeof(mb), 1, src_f) != 1)
>> +			fatal("error reading from file: %s\n", strerror(errno));
>> +
>> +		if (be32_to_cpu(mb.mb_magic) != XFS_MD_MAGIC)
>> +			fatal("specified file is not a metadata dump\n");
>> +
>> +		printf("%s: %sobfuscated, %s log, %s metadata blocks\n",
>> +			argv[optind],
>> +			mb.mb_flags & XFS_METADUMP_OBFUSCATED ? "" : "not ",
>> +			mb.mb_flags & XFS_METADUMP_DIRTYLOG ? "dirty" : "clean",
>> +			mb.mb_flags & XFS_METADUMP_FULLBLOCKS ? "full" : "zeroed");
>> +
>> +		if (argc - optind == 1)
>> +			exit(0);
>> +
>> +		/* Go back to the beginning for the restore function */
>> +		fseek(src_f, 0L, SEEK_SET);
>> +	}
>> +
>>  	optind++;
>>  
>>  	/* check and open target */
>>
>> --
>> To unsubscribe from this list: send the line "unsubscribe linux-xfs" in
>> the body of a message to majordomo@vger.kernel.org
>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> --
> To unsubscribe from this list: send the line "unsubscribe linux-xfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 
